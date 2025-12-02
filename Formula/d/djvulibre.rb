class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.29.tar.gz"
  sha256 "d3b4b03ae2bdca8516a36ef6eb27b777f0528c9eda26745d9962824a3fdfeccf"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "61ac827cdfc87e9056b7490d09970c49b652e26303ce0c71e68808ae11dfc49f"
    sha256 arm64_sequoia: "b57955b6d0b24eff78e60121d490dbff24df02a829f323acde977b46b9b098c0"
    sha256 arm64_sonoma:  "8554c9e53aa97aa0aefaffdddc1d11ee2b2b9378a3cd2a424414a675b689556a"
    sha256 arm64_ventura: "c5dc6a4c1dfbaff711076c51591e0f5e13afcb4377f45627163dc4bec1994a16"
    sha256 sonoma:        "6af726701b6112d300f266ed794040fe2fdfcf8ee489df594841443f0e603f95"
    sha256 ventura:       "e840b0290a5280b98c65201c445f9d079f8ceb506a389297f441354fcc574e21"
    sha256 arm64_linux:   "4be3c4c0603b32ce06a6cd8176e3f7a96e30c482147d900cd8294f80d03f9896"
    sha256 x86_64_linux:  "79310252531b97960283b93c1de09ee14c6c4fcb8e56ca893a5e48fc23a7d2fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or Quick Look plugins
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
