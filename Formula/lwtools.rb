class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://lwtools.projects.l-w.ca/"
  url "http://lwtools.projects.l-w.ca/releases/lwtools/lwtools-4.17.tar.gz"
  sha256 "a93ab316ca0176901822873dba4bc286d3a5cf86e6a853d3edb7a51ecc96a91c"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "382b0f72477f4440fc260f2a055e52cd9aeb22e726a79f351cb35b890d9dcc0d" => :big_sur
    sha256 "121467ab1181db0a5ea6126ffba307c6d6541eeb2dda43532c5437cb6330a42b" => :arm64_big_sur
    sha256 "1ce602bff92ea48cca7732b218e999350d62a3f76d7c69c3e73573da2139d662" => :catalina
    sha256 "3cfae9c3afc0a2fa0d8fdf48c88cb504056f35702f45a4afe5070ceb408d4919" => :mojave
    sha256 "8c0c67d34661986431d9fdb2fe5b6315a0da6b4ec9b4eac139868bfa1ee18069" => :high_sierra
    sha256 "d4f5b062ba3fbd7c7d3115c6f6451fdaa4daf331e0e7f0641580df19dc3c65e4" => :sierra
  end

  def install
    system "make"
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system "#{bin}/lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system "#{bin}/lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    dump = `#{bin}/lwobjdump foo.obj`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert dump.start_with?("SECTION foo")

    # lwar
    system "#{bin}/lwar", "--create", "foo.lwa", "foo.obj"
    list = `#{bin}/lwar --list foo.lwa`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert list.start_with?("foo.obj")
  end
end
