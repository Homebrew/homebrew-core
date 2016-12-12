class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.21.tar.xz"
  sha256 "e6f40bb3f11b71f8004e7a91d9e20b2abe3898d211d0d815c061121bbcddb54f"

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
