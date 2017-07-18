class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.24/gnome-builder-3.24.2.tar.xz"
  sha256 "84843a9f4af2e1ee1ebfac44441a2affa2d409df9066e7d11bf1d232ae0c535a"
  revision 2

  bottle do
    sha256 "206e17861365d087308f30450465cc8804bd4811594dcc92e6f93dd1daf5eaab" => :sierra
    sha256 "c84a17d9b841ef0ba452292961846aa68f094d83e24e62b6b7e6d88349aa3728" => :el_capitan
    sha256 "f6796fc278716d927a75e4c013b620aaf6f6c53ac463888aa500ad44a8eadce7" => :yosemite
  end

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
  depends_on "gnome-icon-theme"
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
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

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
