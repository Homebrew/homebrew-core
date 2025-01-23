class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-405.tar.gz"
  sha256 "f77c8196123ddb0bbb33a40f9fc29862f1df0997e19e19ecd8cbce05b336bf61"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7ba115df7f0b2732813d9cc76acf5c46326ef23ed41a5ac1bf9afae28802f596"
    sha256 arm64_sonoma:  "2fd956f025a295366260df48b9b1b6b9413d6a5f3c9f71543a6f26f604f6a03b"
    sha256 arm64_ventura: "5ee2f4e67ed74af5cea17b602da4b316137fb1579ac9bfb2f33ee1e0ac250a82"
    sha256 sonoma:        "7abe07668a763670004b538dd8fde9ee73f52621b015c2c424b9040e19818021"
    sha256 ventura:       "469acffbe775244383fde055be74a683adc7bd2dacefb32f0468082d0e8f4d2a"
    sha256 x86_64_linux:  "6c4a5d6a8442f8880e47750f614b62e0f1cfe547de683b871d3b2e3830d05084"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
