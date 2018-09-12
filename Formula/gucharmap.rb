class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/11.0/gucharmap-11.0.2.tar.xz"
  sha256 "17e76eacd7c9e72fda21afc2da19d8c3f892814e36ae6f6f561a67bcf9bc9819"

  bottle do
    sha256 "9d7f11d212f14124235cd57c9170551a7ff1f965333448e5bb49594b8bf2ea1d" => :mojave
    sha256 "350a714b5b085203bb43049adb8c2f4b50c9692557c91e25c9b3e071d6a7235a" => :high_sierra
    sha256 "de608586f7faf216b532f88d644448ad9fa714ba3302a576a379ad88847eae81" => :sierra
    sha256 "7c84a8518219abc1e1e96aa365391fcb738c8bef2c07b24ad772acdcc7665b27" => :el_capitan
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
