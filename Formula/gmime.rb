class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.22.tar.xz"
  sha256 "c25f9097d5842a4808f1d62faf5eace24af2c51d6113da58d559a3bfe1d5553a"

  bottle do
    sha256 "b5d17f3cfd4d52cec54202009ffb2bd9bcdde83a907832be6edea59af0202a6a" => :sierra
    sha256 "a80e1965b633a6a5971f3ce343ad65be3df49837542f943e7e346e17f64a9a63" => :el_capitan
    sha256 "92865a7e99cb816c66a02befbec4f463ed4a749cbd8fe99aeaffa509292c2320" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--enable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make", "install"
  end
end
