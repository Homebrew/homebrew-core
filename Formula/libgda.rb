class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.9.tar.xz"
  sha256 "59caed8ca72b1ac6437c9844f0677f8a296d52cfd1c0049116026abfb1d87d9b"
  revision 2

  bottle do
    rebuild 1
    sha256 "1c2fa0318e26d0a3ae3789fa5ebc87514d0e7a7d5068146178f299b9804e8132" => :catalina
    sha256 "206bc82010e8e77ba728eada64bad3d5eaa3b9756c4dd438236103ed89738d1d" => :mojave
    sha256 "e2c155fb503a725f5f8052c975588437a9ed4fc994354d42aad8f81648f0d148" => :high_sierra
    sha256 "52d4df5f60be7e3cf5c1f51dc0318f920cec2f985f951fa533cc69adffcc9897" => :sierra
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
