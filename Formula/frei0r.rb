class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.6.1.tar.gz"
  sha256 "e0c24630961195d9bd65aa8d43732469e8248e8918faa942cfb881769d11515e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e266a992b3858deb72a4d66af7682af477c5e28b0e47006dcaf56f247d80039" => :mojave
    sha256 "28ca48192fd55c2cf008a7a82fadc7336b35c27baae7388f52c6a5b7d2663605" => :high_sierra
    sha256 "c5c4efcf43d6c2cd495c82bfcf3839574b1d7f507b963151284ed186f53974a5" => :sierra
    sha256 "4f4e3e6ed474ba0e667f161e7e05c8cd8a3b67ad67201818ebc0cdac8e737220" => :el_capitan
    sha256 "a8ee4a509fa1d10137a3be9f2791d088606dcd1727079fa681a237ebc65e8fe7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional
  depends_on "opencv@2" => :optional

  def install
    ENV["CAIRO_CFLAGS"] = "-I#{Formula["cairo"].opt_include}/cairo" if build.with? "cairo"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
