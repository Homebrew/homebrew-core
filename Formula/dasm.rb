class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/2.20.11.tar.gz"
  sha256 "c69bbe192159dcf75677ca13bba65c3318dc443f2df45fccd3c060b2e092c7f5"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0c3819d2aafb6fd2daf11de8f9981c607f7dea0fc6244d538be3523816e699bf" => :catalina
    sha256 "73736deba071cce9a0bf233dc4e084a9996a82431334dec3de16770c4630706b" => :mojave
    sha256 "a0b952e00a3c25bb4eb0f7116804355acc87c60397649a18c090008a3030a566" => :high_sierra
  end

  def install
    system "make"
    prefix.install "bin", "doc"
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      ; Instructions must be preceded by whitespace
        processor 6502
        org $c000
        jmp $fce2
    EOS

    system bin/"dasm", path
    code = (testpath/"a.out").binread.unpack("C*")
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
