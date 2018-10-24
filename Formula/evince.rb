class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.30/evince-3.30.2.tar.xz"
  sha256 "a95bbdeb452c9cc910bba751e7c782ce60ffe7972c461bccbe8bbcdb8ca5f24c"

  bottle do
    sha256 "79376de9e7e365c98d51ec709de00966aed241ea33eeb2996284849b05361dd6" => :mojave
    sha256 "00e766f45adca27bb77a032eb7e51d5e0aaafe11e1ad0356f88e1c273611ceb8" => :high_sierra
    sha256 "8b260fa7c0da0fbd2ff4585689049b90fe3cb88260099bf4fc5742ac01dcf32e" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libxml2"
  depends_on "poppler"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
