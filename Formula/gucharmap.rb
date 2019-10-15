class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz"
  sha256 "39de8aad9d7f0af33c29db1a89f645e76dad2fce00d1a0f7c8a689252a2c2155"
  revision 1

  bottle do
    sha256 "02bf0a815ddc6b3cf366c2a4fee899e1dba4c72d2952c4e9df87a52fcf658d5b" => :catalina
    sha256 "9c965568b01c23bb6ef12d997fa2f7335298ac6cba1acfb1ca0680b85a93e198" => :mojave
    sha256 "644ffd53ce114c7790c97183807812121fb681aeb308303dcedbb5c2a889c5de" => :high_sierra
    sha256 "b939644d0bb0ea2f732242acd4bca679a538dd18c8bd2d9ef23cdb37afb5043f" => :sierra
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
