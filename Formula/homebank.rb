class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.9.tar.gz"
  sha256 "d0bc763e94da0cba544495b07070e79faecf1d5de0cfb092d126482525e062b7"

  bottle do
    sha256 "e87951e96143a12682fb91565d3d9112c495e5e91320209a7c3394480755e266" => :sierra
    sha256 "5dde8dedac90082099c4332c45edc524d745029971000e0d4daccb0a60958975" => :el_capitan
    sha256 "e6eb2df7b2a57cd2f81d03acf45177ce13320aa6130e6db0d0f2ea90046d06e4" => :yosemite
    sha256 "92830e910d7d87e9bb59d3aca9da880fd94c7dd623d6742654defa6d90d89fad" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libofx" => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
