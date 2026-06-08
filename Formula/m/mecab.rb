class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://deb.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-3-Clause"]

  livecheck do
    url :homepage
    regex(/mecab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 5
    sha256 arm64_tahoe:   "ce74018f0a73c3efa12971c0b4b8eff444a991564a9cffd1e984438276d0cb63"
    sha256 arm64_sequoia: "da7d689fab24f18de3af9b182f6d821c748c5144cfe5092c7d89dc78832b2625"
    sha256 arm64_sonoma:  "6efae5f3ad07a50740b3ac5d6dff74c213f0a4750bc4531916c1addfebb01550"
    sha256 sonoma:        "1e5516d0c56e44823b881d056d6590d5313821d4a4756729e38bf73786ffc8ec"
    sha256 arm64_linux:   "ae96aae1d823505e8d2beeaa1bbe346b829285874c686c63b2d157f815a000ee"
    sha256 x86_64_linux:  "4496203bcd5ad591b3f99b05fc7175c9f4ea29a3bac57e6d1b1eaf96f4e80475"
  end

  conflicts_with "mecab-ko", because: "both install mecab binaries"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--sysconfdir=#{etc}", *args, *std_configure_args
    system "make", "install"

    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace bin/"mecab-config", "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
    inreplace etc/"mecabrc", "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
  end

  post_install_steps do
    mkdir_p "lib/mecab/dic", base: :homebrew_prefix
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
    return if OS.linux?

    require "utils/linkage"
    library = "/usr/lib/libiconv.2.dylib"
    assert Utils.binary_linked_to_library?(bin/"mecab", library), "No linkage with #{library}!"
  end
end
