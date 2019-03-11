class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz"
  sha256 "6fe4405aa4d2edeedf412befa3cdf423211c80f8836085c4c8c56679658e37fa"

  bottle do
    rebuild 1
    sha256 "edb90dbc1546a8df9923b4768a4731b78bb9a8fd5052873798b1c1d7a4c656e7" => :mojave
    sha256 "18d95b0c22072ee8244e8c2bb513fedf4b745e9573e5a91aa0343f41db45f3a2" => :high_sierra
    sha256 "c9803dfa7e26936cdf408e48f845243e184f1e09d920262cf0ca1f77879f5af1" => :sierra
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
