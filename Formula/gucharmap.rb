class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/10.0/gucharmap-10.0.4.tar.xz"
  sha256 "bb266899266b2f2dcdbaf9f45cafd74c6f4e540132d3f0b068d37343291df001"

  bottle do
    sha256 "955aebc4a270c7a845f59e2843bbdf76a6e3bfd071a4090640da99a6bde5fec9" => :high_sierra
    sha256 "0c08f6630129f2a630a171e5113c16edd830f241d19758cee349ccdddf833c06" => :sierra
    sha256 "abe32c50a7e60d8040a5755c9f026e34fb509727f7146c97dcd85f6304447db6" => :el_capitan
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
