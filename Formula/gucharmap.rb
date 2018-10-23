class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz"
  sha256 "6fe4405aa4d2edeedf412befa3cdf423211c80f8836085c4c8c56679658e37fa"

  bottle do
    sha256 "9c378f03cd0812959ea940e8014acfc38aa21dbebc47b443badb53fc7fe2020a" => :mojave
    sha256 "5b26d5e330593770c86ddc82183224d05cb78ce36cd89c71e9be5eb48ce63910" => :high_sierra
    sha256 "d902d39d58d1cdb90365d23dada129747b6a5ac3e494c24897ab70d306cf4ba8" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
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
