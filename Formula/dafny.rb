class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.5.0.tar.gz"
  sha256 "c1e3b2be851ee1d869d11f177ee8fe23eed3d5ff6fba18001d9816a4cab1d47b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6903dde12fdaa5349d1a0891fafb00084708ef1e5793ddb2aae3ee472e09a21b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "444f6e7a25204f59ec0056157bd6d90dc72645ef2127515c355e651a11ecfcb8"
    sha256 cellar: :any_skip_relocation, monterey:       "167514a459027dd4cee61d3b0991b0e52c12a49f00491fbabe9fd1d9b2c22ff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7ed030a0d86aedc2f821ffb9c71619966c3e4f026f5fe3581d0a662265864b5"
    sha256 cellar: :any_skip_relocation, catalina:       "06f01d6e64589b27aa57c32faada283773245388c73741aec2874f2c44c63acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3dcf85f9eb5e69e10b98015138c4c252802bef4e61ebd4329db80a334437219"
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
