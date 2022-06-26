class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/2.20.14.1.tar.gz"
  sha256 "ec71ffd10eeaa70bf7587ee0d79a92cd3f0a017c0d6d793e37d10359ceea663a"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b9a619d4394ab4079ce4f909549c604aabfd32f1a3ecd96b8e7c30c1cfb823"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc22129ec5a851546aa675a89dc4e6895eac68428914d806cfc03a4bb119eeb"
    sha256 cellar: :any_skip_relocation, monterey:       "39de6472c8ffb52fbeaff1d112b4961b3d0912bbd1777f35db5f7fab46955fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de7ec1bbb50537c46364d86188b6ef07c2e6d6efeee6b013be29eab793290d3"
    sha256 cellar: :any_skip_relocation, catalina:       "354cf4953e70e7518fc7ee0b0861a0be21fa80770a60d18a2c0ea0d31deb979d"
    sha256 cellar: :any_skip_relocation, mojave:         "43a9c82d0ed5d8466cdf1bd749c3a94710f76c5a1f1599a5a4538a58616bc95f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "145c79491ba96ba7d21f4085ff3cedf482555e46c9c334fe6c9b2458202bfb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255217da42c9f1a4b35791323593c0107306e2090fcc69b471d5afb193de7355"
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
