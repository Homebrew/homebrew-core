class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.27.tar.xz"
  sha256 "f9a26a3fc869cfdf0a16b0ea3e6512c2fe28a031bbc71b1d24a2bf0bbd3e15d9"
  revision 1

  bottle do
    sha256 "d6dea0bd60e7d938df31a851f7c2f8f21476114e375b90d54aa3cd1eaa07c0dc" => :sierra
    sha256 "99b512e3c6e36e22c48e04eba8cfdb751b3cf603cb241e5290f2961eeed68aef" => :el_capitan
    sha256 "4de982b7fbbb34b72d38ee56312bcc706ad9857dfe7d2fdd4c0a0c2c34280319" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
