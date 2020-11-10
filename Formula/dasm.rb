class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/2.20.14.1.tar.gz"
  sha256 "ec71ffd10eeaa70bf7587ee0d79a92cd3f0a017c0d6d793e37d10359ceea663a"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "775182ffbc11709b19311978f7a7390cb550203cf6451275a2860601f66f2682" => :catalina
    sha256 "2dbc0dad5d33e6e51eed0bb58972eab4d15a517c8fe4890c78098b065a7bfdf8" => :mojave
    sha256 "1bc81a0ca38c8fe4615282acae9eca531374ce1271d4812532c33d88729166c3" => :high_sierra
  end

  def install
    system "make"
    prefix.install "bin", "docs", "machines"
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
