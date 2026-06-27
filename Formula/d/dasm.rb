class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-assembler.github.io/"
  url "https://github.com/dasm-assembler/dasm/archive/refs/tags/v2.20.17.tar.gz"
  sha256 "4755532fe8c990c8616b4cfbe22c3fe5820e40476343da01e088b617bd2d1144"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3edd10ff681a6fea351120250dc02b0640ac24a85e5ea7e56d16ac8162801625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac5f1a65d96fcb5e45521a5b4ebde8d71a407a2e3223084fc568b4a7dbacf2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891739375850c3e581f3c57cf22cc82d186a77f15a1d17b35a78054bd0065ade"
    sha256 cellar: :any_skip_relocation, sonoma:        "246f772e93f80298df34cba524f046a29a8915ffc9ffb25576534f195e815697"
    sha256 cellar: :any,                 arm64_linux:   "e80748c2143de6f164947545aecddd2444af087532e41bf41a75abd4bfe7ec3c"
    sha256 cellar: :any,                 x86_64_linux:  "e095df956364650b7a98371f56b299d6695b2f30d0ada607fa899ad4032e098b"
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
