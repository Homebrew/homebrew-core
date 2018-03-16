class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.24/gnome-builder-3.24.2.tar.xz"
  sha256 "84843a9f4af2e1ee1ebfac44441a2affa2d409df9066e7d11bf1d232ae0c535a"
  revision 6

  bottle do
    sha256 "99a92dbc14dcbbe6451f0b004c975acffd55d47a4f90c0a7cea81c40c8a08666" => :high_sierra
    sha256 "bfaeaef536370644d2e810f77b5ca6a27b5ef706787ee66e570dcff4ffc7eeaf" => :sierra
    sha256 "bd17c12b9baeeffe37967c4932e0b0e12db5fca2a51652614101acf6e9561691" => :el_capitan
  end

  deprecated_option "with-python3" => "with-python"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "coreutils" => :build
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "gspell"
  depends_on "enchant"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "ctags" => :recommended
  depends_on "meson" => :recommended
  depends_on "python" => :optional
  depends_on "pygobject3" if build.with? "python"

  needs :cxx11

  def install
    # Bugreport opened at https://bugzilla.gnome.org/show_bug.cgi?id=780293
    ENV.append "LIBS", `pkg-config --libs enchant`.chomp
    inreplace "doc/Makefile.in", "cp -R", "gcp -R"

    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-builder --version")
  end
end
