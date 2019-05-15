class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz"
  sha256 "39de8aad9d7f0af33c29db1a89f645e76dad2fce00d1a0f7c8a689252a2c2155"

  bottle do
    sha256 "9bb1d5a9b175c4297aad6e9bbcf4c205939ee10988c5f331ec3d18ba0910f1bf" => :mojave
    sha256 "8afb998c47ced996ec89d5820d629c8dd479023f2f80d525227878f1f67eeb57" => :high_sierra
    sha256 "ad46ff5cef59ac214eb3badf906823d8948c6817a68bcb48ac08f04fe083ea4c" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gtk+3"

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
