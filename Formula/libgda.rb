class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.9.tar.xz"
  sha256 "59caed8ca72b1ac6437c9844f0677f8a296d52cfd1c0049116026abfb1d87d9b"
  revision 2

  bottle do
    sha256 "42e417224880411d28719e1e72d5dc455a7f5af416acd178af7c6ad44b484a28" => :mojave
    sha256 "dbdaf5dee8343c6824d5c987f4e12a4fc861373f3747a24b5687c5a0b413e623" => :high_sierra
    sha256 "92409ba0caf79679d279e44a7ed619ccf76d52bddcf49d4f8ce2efb6b5baffc0" => :sierra
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
