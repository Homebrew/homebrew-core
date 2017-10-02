class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/10.0/gucharmap-10.0.2.tar.xz"
  sha256 "331e053078d6834ad6d2a2ffc10c063050564c04777a69caa10d4ebd69683493"

  bottle do
    sha256 "634aef5eb19e85cefd70dd71e3947f38b1efc91b12d9909a8b060d64ef5af44f" => :high_sierra
    sha256 "79efd3d1fc9980a07fe04e5c2856bf130766a95c7e85c00e197e7495a128feff" => :sierra
    sha256 "871580eca0eae53d748d1292430d3f28214b99a2af0ea79ea7c2d7c66059f9c7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "coreutils" => :build
  depends_on "gtk+3"

  def install
    ENV["WGET"] = "curl"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no",
                          "--with-unicode-data=download"
    system "make", "WGETFLAGS=--remote-name --remote-time --connect-timeout 30 --retry 8"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
