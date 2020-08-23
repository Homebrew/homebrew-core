class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/2.20.13.tar.gz"
  sha256 "48be84858d578dd7e1ac702fb2dca713a2e0be930137cbb3d6ecbeac1944ff5c"
  license "GPL-2.0"
  revision 1
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a55169cf45fc0d3d61dc77f69c0817fed7b28b66206a93e2c8f7715f867199ac" => :catalina
    sha256 "45e8803c881a3ca3a3c7c1c45a5fd55185ba804765b0512971d798c04b1626fd" => :mojave
    sha256 "b6c8d3f75172985f0f60172e654785fee331070fdd4c0fa58c4247db8c0ac192" => :high_sierra
  end

  def install
    system "make"
    prefix.install "bin", "doc", "machines"
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
