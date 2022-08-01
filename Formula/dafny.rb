class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.7.3.tar.gz"
  sha256 "a56fba9687d5375353fc0bdb3c6df9fed19b365720e95f7c78fb92d2ab462f71"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7448e2c6df507fbecdc8fc2da07efe0c07e88d07ce95fe004b0cde7cfdf90ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4abb5287ed4ac2e7f5e3ca75999327f1a9181ba8ae8e02362376432578e4c18"
    sha256 cellar: :any_skip_relocation, monterey:       "639b201b65eec7327185c5619d718e353811fd9c0595db0da33a26b0803758c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c63d366b8604b46161983d14a41b7a9f40fc4d934504ea34e10a516bc75d04"
    sha256 cellar: :any_skip_relocation, catalina:       "774d61db54a3ad9e3d4d7a95e6a9d452f9c18b11a770fd4986b5bff9a21bef15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f7b41ad692f181011a87d6eb9fcbbff65d074f61174b0b24b02a49566cca2c"
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
