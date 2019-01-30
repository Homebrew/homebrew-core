class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.8.tar.xz"
  sha256 "e2876d987c00783ac3c1358e9da52794ac26f557e262194fcba60ac88bafa445"
  revision 2

  bottle do
    sha256 "082aaf92e18ea5644d48a16ec18fd0d1d19efa7118ec17fdeca106cf8fd4379b" => :mojave
    sha256 "1eced12e9536d31c56e32cf7d3734f872e7e187160ac9ba51a3a53f1b260c254" => :high_sierra
    sha256 "4ce20eab3e051395f5717c176d6e79d00bd3ba8a2ee2e507c5559adb0245ebdd" => :sierra
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
