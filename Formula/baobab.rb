class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.26/baobab-3.26.0.tar.xz"
  sha256 "ca07c18c8582f6c2fcb54b414f0b9057ebe53e54296c3ce9ccee44b78e86b2db"

  bottle do
    sha256 "036e138c507f190b7fc243911d8e2a9426235fba7932097a79f2361fb1a7437c" => :high_sierra
    sha256 "24d64fd6acefcf26f71bf121bddae4a3749515e47de2ea233642d99444804f06" => :sierra
    sha256 "749b46d3a4e2d3ca1fb1969ccd85a5f0ec844e1a5dbb824173627af172b862e6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
