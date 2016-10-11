class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz"
  sha256 "8617ab68f2977cc3780a1f39264a48b8d9cf8824172c442fa9ca1c11d81dbd6c"

  bottle do
    sha256 "8266d571f17ad5e20187b3263e8281797029d7923174adffb84f82c58545a884" => :sierra
    sha256 "06186093bec56c46d2e7fb324d9113baa6537f7f8eab15a26506a0af9a18c455" => :el_capitan
    sha256 "b548116c6f0ae5a020dc6d6ab36cb036ee6edbc07cf29fdcbf6e02d4c32a5f84" => :yosemite
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
