class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.9.tar.xz"
  sha256 "59caed8ca72b1ac6437c9844f0677f8a296d52cfd1c0049116026abfb1d87d9b"
  revision 2

  bottle do
    rebuild 1
    sha256 "07b04e77c649dc8c3e8af1eb1137356384c571933f2cb11f2c65f9892083d4b6" => :mojave
    sha256 "0b49c8dfcc3ed6795a38b4fbefb54423dadcf2344b65ce1f154e3fa948112511" => :high_sierra
    sha256 "684c85fad37d67323593150e75d06b7a08c038ec7c814f67cf1f72b7ca92c2fc" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    # this build uses the sqlite source code that comes with libgda,
    # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
    # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection",
                          "--enable-system-sqlite=no"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gda-sql", "-v"
  end
end
