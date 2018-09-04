class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.30/evince-3.30.0.tar.xz"
  sha256 "cbd02d1c515fd7f17af1c96935e456d6ccba4d612d2d972a12079cc6b24e8cb9"

  bottle do
    sha256 "c330bc3a2c64ffc3803a017f474a9c489d8f69d8f0f5224bbe097048c4327394" => :mojave
    sha256 "466d27c9e13812ae6c8af2724f17b441e5b13276169ae210063684ca0a58fcfc" => :high_sierra
    sha256 "ceaff8decdf09f5b4caa2456d4b5fba3d01f59d0434c764f5e8250383a1edbac" => :sierra
    sha256 "e98ecffeb5353979ed7c433de951711cbb337efd1450491025feb7faa872a7d4" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
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
  depends_on "shared-mime-info"

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
