class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "bbdef1b93502fa3d1d387f98f097b5cec2e21ea9c282aa08ad1ac237a7177fa0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f7259a1480d910f480527fc387512fba2628584ec05a10f12bd796920bc7eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52ae72a91e4ed3223a45297036f62204041c97d5cc9e3d90c38024dc3802274e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0e370cc659c409235489288f121d6a12cdaa3faef8db9cd2e2c621147b12ae"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b15828192b3d5213fce6c6963bf44888c0b255a2a1706ec4b88b87c6f687d7"
    sha256 cellar: :any_skip_relocation, monterey:       "e7b5cad0ddc98622bd8734015f9d12f5877fd19d505ae7d69f2bde0a7aa21db5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c428ce095d013b0e25d9c71e7bd51a8f1d3accca85d0afc39e302ea284931f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ba13f9b5d77fc22acc26147d9dcd92371c6c6c76577b6de015699dbbf4e0b3"
  end

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"

  uses_from_macos "python" => :build, since: :catalina # for z3

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    resource("z3").stage do
      ENV["PYTHON"] = which("python3")
      system "./configure"
      system "make", "-C", "build"
      (libexec/"z3/bin").install "build/z3"
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@6"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /compile:3 #{testpath}/test.dfy")
    assert_equal "Z3 version 4.8.5 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
