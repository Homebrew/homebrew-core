class Iprint < Formula
  desc "Provides a print_one function"
  homepage "https://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "https://deb.debian.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  version "1.3-9"
  sha256 "1079b2b68f4199bc286ed08abba3ee326ce3b4d346bdf77a7b9a5d5759c243a3"
  license "GPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59184069028344bc9b2d24985c049efc45ededd3f8aff7d82bdf6692545f6f63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb538fa6b5466dac71f52ec8f428e4ef0674e1f475893879a857cf27ce914a9f"
    sha256 cellar: :any_skip_relocation, monterey:       "56bca76cab2c3618c905d90160eeefa4e536913e7641ac29e4ee48c6bee7a674"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4508c0b9eed2e203735de1d864dcd4ba35cb7279fb95eef28fbae2cd8d9d41c"
    sha256 cellar: :any_skip_relocation, catalina:       "e5fba1fa985ad96aac02d36f50e0985c14248655fd810c15c053e1ff7d5a1981"
    sha256 cellar: :any_skip_relocation, mojave:         "8b1752455e0ff26b804070e3eb710493342fc2b2897a132a26433f4cabf5ec17"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c71f0b21d59a21fdc1e86e0a2016f79d862e838eb0fb7c92c50ed56e8aa1a163"
    sha256 cellar: :any_skip_relocation, sierra:         "3fc40e5d2ee26c7b8709bf61e651ec3506561b98fcbf6ca52b8d353dd4be356d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "caa018741bb84409295f4fec33bcf427df199e717abf1323c9325d44238548ff"
    sha256 cellar: :any_skip_relocation, yosemite:       "eb0a1df1375a29fd3a88cddbe844820c9650b4ee14406245ee5d93ad41e48586"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    sha256 "3a1ff260e6d639886c005ece754c2c661c0d3ad7f1f127ddb2943c092e18ab74"
  end

  def install
    system "make"
    bin.install "i"
    man1.install "i.1"
  end

  test do
    assert_equal shell_output("#{bin}/i 1234"), "1234 0x4D2 02322 0b10011010010\n"
  end
end
