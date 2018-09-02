class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/11.0/gucharmap-11.0.2.tar.xz"
  sha256 "17e76eacd7c9e72fda21afc2da19d8c3f892814e36ae6f6f561a67bcf9bc9819"

  bottle do
    sha256 "0ba5d5b0e3b45fc66d9568e9b18c6bed85b486e2e2e9eef92d6ef29c8c5116ba" => :mojave
    sha256 "ce68b7dd70eadd29a809252189b6d6ff5f76aa148df1c483314946fd6991922e" => :high_sierra
    sha256 "620a04f5700067b146dbde3f30ef940a1c718bb8b589fd409d4ff4b7e223155f" => :sierra
    sha256 "d4ae8426ee7b26ab5b0ea79df0102ffdc2a670a4e078d9948324ba3529ca3a84" => :el_capitan
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
