class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/10.0/gucharmap-10.0.1.tar.xz"
  sha256 "51a2bf91c4590ea2159f828156864f088a0bd4c12e7a1c396002a23d48b2d5e2"

  bottle do
    sha256 "2f19b3effb9e7961b62cdd311e676998014da1d0c8eeb9610a2834b28a5af890" => :sierra
    sha256 "3fd1a8571d12e197ab306aee8256e3244ae23ff0c092d890c329dc741ef306a2" => :el_capitan
    sha256 "e2ab4eab90220fc7d5f04c7fe8257e9ffff04ee811d584cd2c0ee5efe3697131" => :yosemite
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
