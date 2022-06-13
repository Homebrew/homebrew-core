class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.9.tar.bz2"
  sha256 "8649962c41d2c7ec4cc3f438eb327638a1820ad5a66df6a9995964601ae6bca0"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "96ca29781e7f74b144ef7029fb650f58a63178f2f01e4d00910f2583664e228f"
    sha256 arm64_big_sur:  "0e086fbcbbb7d62b119b552c98bbc99ffe8973d2d465ad584f21513bfeb70699"
    sha256 monterey:       "46d0dd22ac24cad231c062db7fc976e9c063db0c378c1d09bb982560b9800d49"
    sha256 big_sur:        "4f8e3234a0e99a27922f09414954726acac8adc2de6a85f75718e8031d4b11c3"
    sha256 catalina:       "002130895cb948284091e2027ae7cab3f088524165aeb56b8d38d62cd92b7095"
    sha256 x86_64_linux:   "636aa4fd9eab787ca0174fc73e1762b758f913947ab10d22762431d3e27b3f6b"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
