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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 arm64_tahoe:    "e0bafdf893f0650942b7482f0ae672094f530a37d18cc3047932b90a2a006a16"
    sha256 arm64_sequoia:  "9a6615d4ecdf87686bcc81e8851929a24661604782f48a0626a2e74762a20fa5"
    sha256 arm64_sonoma:   "b442dff5851dc2e529a82d84a59b135e6f79ba6af1f295589e776aa2439d71f6"
    sha256 arm64_ventura:  "b64f24600f7e8cad0dd98a985b72a446db41af35a192261ec489fc059e9a354f"
    sha256 arm64_monterey: "99d7d453a35685f10cc15e0135d7ec612b9d695e58a2d36032daef5b6dac9a6f"
    sha256 sonoma:         "d91a5e1bd7fdea15cfc0469705b33a71b02ad5c2ec2a599ab49829d9a6baa916"
    sha256 ventura:        "361bce3217483e859b5c6d364da2ea098c63058411ed5324af8bf6c018046fef"
    sha256 monterey:       "754a860b791ac92d825d4ff6b6b1f63e7c31e8983e603e844d1e4675732f343f"
    sha256 arm64_linux:    "8181ec221a72b26be40c3de033dd8196d70c01d776b912f90ec5effd50731d6c"
    sha256 x86_64_linux:   "f730abd5e95a325a9e2e012ac01714e9a22e694d91e5bb026d501495d9899ff6"
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

  def post_install
    (HOMEBREW_PREFIX/"lib/mecab/dic").mkpath
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
    return if OS.linux?

    require "utils/linkage"
    library = "/usr/lib/libiconv.2.dylib"
    assert Utils.binary_linked_to_library?(bin/"mecab", library), "No linkage with #{library}!"
  end
end
