class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/refs/tags/v2.20.18.tar.gz"
  sha256 "6cae2ff107c7447d601366f75a1dad86504deff7fe4c0181c145dbc83e249aaf"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "611cebf8b3746e4151bceabb6277e6869f063b568befa7ddc7db1b386111861d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "131783feaefc2e3ad6f5528895640b78e9de7d824a9d9a383288791c7bebcfb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccd388fa7ab9a514c2ec04eb7799791e9ef627da59cab3ebb41f8f39c767297c"
    sha256 cellar: :any,                 arm64_linux:       "6ae9be783ac1ed6abef2dedf0fb04d31ff51686b7c13b5827f1916853010e33b"
    sha256 cellar: :any,                 x86_64_linux:      "154f8ae7147d1d5cadb79c70b0dcf10c154385ef23cbba036317998d5163dac5"
  end

  def install
    system "make"
    prefix.install "bin", "docs", "machines"
  end

  test do
    path = testpath/"a.asm"
    path.write <<~ASM
      ; Instructions must be preceded by whitespace
        processor 6502
        org $c000
        jmp $fce2
    ASM

    system bin/"dasm", path
    code = (testpath/"a.out").binread.unpack("C*")
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
