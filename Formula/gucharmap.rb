class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.4.tar.xz"
  sha256 "1588b2b183b843b24eb074fd0661bddb54f18876870ba475d65f35b7a9c677a0"

  bottle do
    sha256 "9f06aa1932c1b7800f82b3436e30dcf2eb0d4fb101bf1e7a862d807dc4f4d71c" => :sierra
    sha256 "4a19f73456549fd9aeebc7dcf98c1ccd7134e122a46b15af85f895c8eb193cb3" => :el_capitan
    sha256 "b1b1545ff68dece26fec91acd541c058f405fa8645903a93a3cb6e5bb95b0aa1" => :yosemite
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
