class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "901b7e39dec8ac96159f32ac2fc8d795c3908d37788c80ce736754d4b6e142b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6031cf147a75453f74f52c16dabd08c6939a346527d4112516603495c772eb89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e544dbe75bd369172eeb40d3748c7cb8d86d5b1217e1b4f4e10140a523506a7"
    sha256 cellar: :any_skip_relocation, monterey:       "402c9b1308c42c8c5f5e6a09bdb3aed749d26704c455208dbbc88f3336d81b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac8bbb1b1cba0a85502154e8a155071793cf05cb57f5eeec58953fb8121293fb"
    sha256 cellar: :any_skip_relocation, catalina:       "8af0cbd7672b5c16afdbbcc2dd51f7dde9ae13d7135ce7d3267fe80d1566fc20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6385c1d7a33f5faec36e4563c613def25ec2fa7a41741b6cd091c863cdbb35"
  end

  depends_on "gradle" => :build
  depends_on "python@3.10" => :build # for z3
  depends_on "dotnet"
  depends_on "openjdk@11"

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"

    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      ENV["PYTHON"] = which("python3")
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      dotnet #{libexec}/Dafny.dll "$@"
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
