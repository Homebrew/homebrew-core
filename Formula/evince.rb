class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.28/evince-3.28.3.tar.xz"
  sha256 "9c02e8d60d36b73cded2c61d858453504ff0550eb4c4e598376284f72ec20642"

  bottle do
    sha256 "885e2ea1bcc437016e6237ea4a43552878078baa460279a9f918af703494ec0b" => :mojave
    sha256 "e798fb7ca35833677970456d9902e07c70adf43c56c4a85ce7dfe376ad6e0db1" => :high_sierra
    sha256 "7c81ed517fe583d05561224deed4d37771ba5280345361b771fe362a8c4c73d3" => :sierra
    sha256 "9a417f126fe8cba7c999fd2bdb4e5f44360e37f36883a664312cb85c88f5b78d" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "poppler"
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "shared-mime-info"
  depends_on "djvulibre"
  depends_on "python@2"

  def install
    # Fix build failure "ar: illegal option -- D"
    # Reported 15 Sep 2017 https://bugzilla.gnome.org/show_bug.cgi?id=787709
    inreplace "configure", "AR_FLAGS=crD", "AR_FLAGS=r"

    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--enable-djvu",
                          "--disable-browser-plugin"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
