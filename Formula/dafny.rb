class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.7.1.tar.gz"
  sha256 "6d77fca0875bdac4ef9167b1fd72bb9de02fc60bc01be3d8243d224709e50ec5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9827947070d8bab2583703e7a875d8cb41126af68cb9cbbd85cc3002d6a3f7c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf88b1dee519ad8aa4a5fa18c7ba52c9ef03b24fa492e83f85dba288540061c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8202034074f14a33044ca687be498411e20ae530fcec2a8433251469e7619702"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b0bd384d25b23e23033250d71fe9d5c009f2721f39ead3535db64148c52d0d0"
    sha256 cellar: :any_skip_relocation, catalina:       "ca9f0b53a0ce999f87425e046be82f1ae0b0b2c7ba8da14e64b160cb2e099c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38c25c11d897bdda81239e4dcfce449ccbdc749a1b558c5f9576557e7fe3e8e"
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
