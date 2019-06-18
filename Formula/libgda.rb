class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.9.tar.xz"
  sha256 "59caed8ca72b1ac6437c9844f0677f8a296d52cfd1c0049116026abfb1d87d9b"
  revision 1

  bottle do
    sha256 "6c093f6c1e2b9cb2c2193a4df821a7783415621352fa97094eac0c7836c28bfe" => :mojave
    sha256 "706c6863db85e4f68a153a9dfebb1b6d8644c0712b83b21d8ca28edf3fed2eb4" => :high_sierra
    sha256 "e9d2600117bd0627799e8644bdfc8a7cffe49dcd4ddc318716f5ae7ad02c4098" => :sierra
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
