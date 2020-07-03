class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz"
  sha256 "39de8aad9d7f0af33c29db1a89f645e76dad2fce00d1a0f7c8a689252a2c2155"
  revision 3

  bottle do
    sha256 "732ed6b19cd29d595941397082369c61c35a4e960ca0b36e4dd306cc7a97b06e" => :catalina
    sha256 "a01bf4f29277930ae3376a8d6a69c762d95ba0d1e2807af55f7ec8e3c41866cb" => :mojave
    sha256 "9c3fbd03c494d4dfa3f126d070e033529aa71d1902674d1b70c1c2ccb73f5835" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "gtk+3"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    ENV["WGET"] = "curl"

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
