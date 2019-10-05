class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.34/evince-3.34.0.tar.xz"
  sha256 "3297d16d2d1426f72ea090749ba72424d08eb133fbe4101e52a0b84999ad2a51"
  revision 1

  bottle do
    sha256 "74452e248358bd45211011c77ec0103dd3c136293c01b87cb657c5b95d8ba651" => :catalina
    sha256 "0bc52bf882f3f853871f31e01dbba7d3af03c3b6d58143e0e428323d929a59f2" => :mojave
    sha256 "7c76bdef7f3f9960068d9055da070f1255329526be49ad2565a75a68c097409d" => :high_sierra
  end

  depends_on "appstream-glib" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libxml2"
  depends_on "poppler"
  depends_on "python"

  def install
    ENV["GETTEXTDATADIR"] = "#{Formula["appstream-glib"].opt_share}/gettext"

    # Fix build failure "ar: illegal option -- D"
    # Reported 15 Sep 2017 https://bugzilla.gnome.org/show_bug.cgi?id=787709
    inreplace "configure", "AR_FLAGS=crD", "AR_FLAGS=r"

    # Add MacOS mime-types to the list of supported comic book archive mime-types
    # Submitted upstream at https://gitlab.gnome.org/GNOME/evince/merge_requests/157
    inreplace "configure", "COMICS_MIME_TYPES=\"",
      "COMICS_MIME_TYPES=\"application/x-rar;application/zip;application/x-cb7;application/x-7z-comperssed;application/x-tar;"

    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--enable-djvu",
                          "--disable-browser-plugin"
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
