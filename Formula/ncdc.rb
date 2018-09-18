class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.20.tar.gz"
  sha256 "8a998857df6289b6bd44287fc06f705b662098189f2a8fe95b1a5fbc703b9631"

  bottle do
    cellar :any
    sha256 "08a9bceea86394663db9b7abc8b5d8033afd1dbbcdfde15cac5b4b1c43e9b0d4" => :mojave
    sha256 "8c9d1049ef2493d21aba8eb961e98de27b187de8b7cbd18181a26e7889a2e030" => :high_sierra
    sha256 "1e882285c9367191a63d62cea2f539b22f9d209593649d6f3fb6c7a472cc2eaa" => :sierra
    sha256 "05b153207799eae9250516bfd51b41e0069f94155d727ec69a016db96bdfa349" => :el_capitan
    sha256 "8655d4cda874055cadc3c02f1a1929385f1d8e08e7f5b7fa0a6a8971321aeee8" => :yosemite
  end

  head do
    url "https://g.blicky.net/ncdc.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "sqlite"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
