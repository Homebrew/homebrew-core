class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.4.tar.xz"
  sha256 "1588b2b183b843b24eb074fd0661bddb54f18876870ba475d65f35b7a9c677a0"

  bottle do
    sha256 "e480d0b42e959069a5c6ac5e0971832025432a7af8366782b79cf207dac6b6da" => :sierra
    sha256 "bc417d1c6ad0caf34495a1be3cfae59f070adb529af9a637a1806910e109177c" => :el_capitan
    sha256 "564bfe6886ff9f646bbdd3406ace12181f01fb1f0290f8778adbf082a1fd7791" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "wget" => :build
  depends_on "coreutils" => :build
  depends_on "gtk+3"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no",
                          "--with-unicode-data=download"
    system "make"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
