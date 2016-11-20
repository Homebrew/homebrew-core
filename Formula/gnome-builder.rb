class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.22/gnome-builder-3.22.2.tar.xz"
  sha256 "304dd841f35aa4acb256c3466dde91e808298152e2918a1ed86116b5f5a2c54c"

  bottle do
    sha256 "26c78b1c5b8427370f8139b1ce96f18dbdde8460c8012d10203145bb9ddc0723" => :sierra
    sha256 "bfcf48e28193ea7b67c575f601945f01384313a4e68f93ba9d9108cf47d711b4" => :el_capitan
    sha256 "5350bde775ef3f78b4ef18600e5ddab0b4039ea0540552824762ceb83371810e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "mm-common" => :build
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "json-glib"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "devhelp" => :recommended
  depends_on "ctags" => :recommended
  depends_on "meson" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  needs :cxx11

  def install
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
