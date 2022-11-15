class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz"
  version "71.1"
  sha256 "67a7e6e51f61faf1306b6935333e13b2c48abd8da6d2f46ce6adca24b1e21ebf"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "551de1e60e6f979676ee4e829a8485c2d326a71e6b736299356880c71ec3bc8c"
    sha256 cellar: :any,                 arm64_monterey: "0bf3c66f005e2d7662375b4baadd3022d57294947f421f9f8628799008a987f4"
    sha256 cellar: :any,                 arm64_big_sur:  "5cbb7c32192790d114f179ca9456df9a5cbd0094a9e2383c9ae8e4ec5e5cd568"
    sha256 cellar: :any,                 ventura:        "012f882f239863200f0f87150541ea695d609aa14c14a390909d249352ae51f9"
    sha256 cellar: :any,                 monterey:       "87617a04333c53236f5174f5a3fa70458d61d735024ed477c0484adf2c3f80d3"
    sha256 cellar: :any,                 big_sur:        "4c2904b4e7af60796e202d9f5ced39443ffd657b61a007b67bd109534b00c03f"
    sha256 cellar: :any,                 catalina:       "0182e3999a76593888bc2b5d54c275b6d7f0eb75db354a3a37925179a9e91d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bcfb2f075f7ea40053a09804479bef4457b1f7f606617fb15116edef53c2e9"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args
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
