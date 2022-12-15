class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "066e1b84a552903acb389c5fbb67e65763bc2cdea463ba7a614649728adaafee"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c33fdd0645a7c5bdc180de08d1bf0c53a65205740f916958879a5b7ebfc4ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96225fec5fa5c4f4551350f3c9536b84b342d44fe8398d056a619c5f9e87c5a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e030554bf8a73d784abdb584ec56689c8dbbf835173bfef350eea22e4f750e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f4dac9989d026a93436ada464b85b96a046feecb28fc903a9e786be9e31749"
    sha256 cellar: :any_skip_relocation, monterey:       "b84d63d436989f071f1bfe80cb05877a26ab7d0a4848430aabaa50a6e129403e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6db69ff1a278c2270235fff976230351234f0daf1afab71f4fca8b2de972baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c9aadb6c2dfea6b5d02c4cd727477eb908d614276e032e3c6cf2f9bb07d9863"
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
