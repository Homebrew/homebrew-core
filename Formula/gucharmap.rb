class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.0.tar.xz"
  sha256 "cdc3557a38a96d8163f81ce5bdec777bc4b652b0e069fdfa5144f5f0561b0ef9"

  bottle do
    sha256 "624f23f65da3344f90003411bc5251f53c4088bf8f3daa3d8bfd961a13956eb0" => :mojave
    sha256 "a83feceb2027332049a949794926b9a7d4fae3f15bde8982ee427ce67c85eee5" => :high_sierra
    sha256 "1b4ec80d055a64e9e51159532170a1996cd0ceba96307d758aed38d8f519bfb7" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gtk+3"

  patch do
    url "https://gitlab.gnome.org/GNOME/gucharmap/commit/f832495aeeeb6b20a598b895261a9d1853005147.patch"
    sha256 "d86f94bc4b73503d7653ee4ac77fabc00ceca4f9063f33141848af4a335b0f95"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
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
