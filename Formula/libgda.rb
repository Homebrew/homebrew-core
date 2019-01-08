class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.8.tar.xz"
  sha256 "e2876d987c00783ac3c1358e9da52794ac26f557e262194fcba60ac88bafa445"
  revision 1

  bottle do
    sha256 "9e960408acc8636172f0d2c22d3f51849ac684bbf035efcbfd582b293854b2a4" => :mojave
    sha256 "b5dc9c856c87a69f8322d9d5bacec286d92888ded89ae46767e501bf61f361cf" => :high_sierra
    sha256 "e966216bc9f7f8deb555630d2606409dae1c3dfed0b6234c2f01540d0dd14551" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection"
    system "make"
    system "make", "install"
  end
end
