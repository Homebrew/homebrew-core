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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d026c27ebe538391b935c2ab0d6b9bda0f86e39fd989be919d74c112d2daf5c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8b2f16958dc972922b3ea63a9b48b5e06e337ecd3f6a7e4a010d60350324546"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8805a027e2d57019dcad19cbbe90180051ced1f67944dfbf4efc00d183937f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5afb440ff7de08be4f67a234c6953e24f7c42bb5878263829208a9c4d268fa12"
    sha256 cellar: :any_skip_relocation, catalina:       "c379f5440e436b8ed05cfe36b58e8c74df0f2dd4f687b6693e5caa113348f814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7a7b40904f4999450c403d80d701bd6409962eb83af16def573c168e46f266"
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
