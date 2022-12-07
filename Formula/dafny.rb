class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "77272ca990c4555bde5a31335227b2ba7811c29c5bc8a4381bf7cfd1294a2f20"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbed4974a3c1f4039d29c96e01b5a37335f9d44d77469cd0318286e574e89316"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dcfdd1a53f57769ca84a8d5206e537f395e1bf491af1bb8d2971ebe61bfb2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1814604235ab9ca7cb271bd62226bfe90337ae772f7ede97c74a3ab79ebb1192"
    sha256 cellar: :any_skip_relocation, ventura:        "5dab2145295503018a8096ca3107ebce04a0a43414d9136fd42c7a1118ad00a3"
    sha256 cellar: :any_skip_relocation, monterey:       "02b36ed059c898ea7bf24853b5039d0136076a5a5a73dae00b594fa673b25f74"
    sha256 cellar: :any_skip_relocation, big_sur:        "162f5e66b082353ad318d54f7588c72ba8d622b98c894b357a4de0317b43a1d0"
    sha256 cellar: :any_skip_relocation, catalina:       "8d5e1bead5ee82461e505e1f5c2caa0890bb9e79cbdd7576ad79339ae33ea3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d87dc6b3a2041668a3e4100d3e44c61bee2a772a8405fdc8fc63d1ac35a200"
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
