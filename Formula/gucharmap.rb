class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/10.0/gucharmap-10.0.4.tar.xz"
  sha256 "bb266899266b2f2dcdbaf9f45cafd74c6f4e540132d3f0b068d37343291df001"

  bottle do
    sha256 "8e66d0f58851f04897ac63b0f9ee7cfd91acf3541c99d95d6b3a29525e1e9a95" => :high_sierra
    sha256 "ab903d4ff50237f7acc92d392c7698ee587a0044cf04b0e6532380999c59602e" => :sierra
    sha256 "1621514f7a95157b810a706362811ac26b557dcede3ef797be1553a93ca8a43c" => :el_capitan
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
