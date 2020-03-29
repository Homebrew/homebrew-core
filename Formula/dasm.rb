class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/2.20.13.tar.gz"
  sha256 "48be84858d578dd7e1ac702fb2dca713a2e0be930137cbb3d6ecbeac1944ff5c"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "54c2988c24790b173b9524e7b91608b1575d1dec6f344040e17a473c58c4723b" => :catalina
    sha256 "0d4afd62aa5fb3f286772f3823f10e0d46d78de5c45812005a51882ccf8a08f1" => :mojave
    sha256 "ae8fa7144bdd458c096edda1960f226cf1202a2f3ed226b5ebbbc0ee27c96208" => :high_sierra
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
