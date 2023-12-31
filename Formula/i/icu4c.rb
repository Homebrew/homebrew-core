class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-73-2/icu4c-73_2-src.tgz"
  version "73.2"
  sha256 "818a80712ed3caacd9b652305e01afc7fa167e6f2e94996da44b90c2ab604ce1"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "734c09d5285cf68f3c86c09522f6f24734bbe6d7338c4900d89092bcd9fb8fc0"
    sha256 cellar: :any,                 arm64_ventura:  "953797d46546c570c4fab4e8b2395624ae90acd492f75b68ff99fbd115ccd748"
    sha256 cellar: :any,                 arm64_monterey: "488714896b377fb1bb09f023e0740235730be9098a2bf70e932cd9d1386d4a4a"
    sha256 cellar: :any,                 arm64_big_sur:  "d51cb68a129278f56d544937e381c8f1deb5edc8a20c40aeb50c6fee93d8eb1d"
    sha256 cellar: :any,                 sonoma:         "5e416eb34196809126fe5465b776f355abbd4cee61c28e63d059a8f57e8503a6"
    sha256 cellar: :any,                 ventura:        "4400e31a217d6ffcd2bd06e26ecbeed768133493bfcc4cb3c9ff9702f480beb6"
    sha256 cellar: :any,                 monterey:       "56abe168ef97fdee2bc2a8d0634c235b54cb7c2740465ee64053d96cbc755a9b"
    sha256 cellar: :any,                 big_sur:        "707aa80ac7b79afe6047d25a44b90c46ed15fb6f0c255e0057c7dc812a9ab433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714dc987ca9c9b594e6e17c02640f93b49074f81264be16051a93a8f5f674d77"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system "#{bin}/gendict", "--uchars", "hello", "dict"
    end
  end
end
