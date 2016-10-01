class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.22/gnome-builder-3.22.0.tar.xz"
  sha256 "0caf7d917aefb3fa42aa63dbb57d635fae24889c0df1fa585ee29c095ea3dda7"

  bottle do
    sha256 "24466989c87e1a178d7ffa393fa78e3d32ea8ce914843fbba570667f5c35b664" => :sierra
    sha256 "60b4e4be0be0bfaf955650768e5bc811a18c011fe8f1fb2a00c1042b885af458" => :el_capitan
    sha256 "ddbe18f4f15048d423b41b9ea0a7819692184e8b503a1b6337b8595b98cbd846" => :yosemite
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
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "devhelp" => :recommended
  depends_on "ctags" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  # bug report opened at https://bugzilla.gnome.org/show_bug.cgi?id=772279
  patch do
    url "https://raw.githubusercontent.com/tschoonj/formula-patches/gnome-builder/gnome-builder/pipe2.patch"
    sha256 "9e5ac0f1ab8dd5931a28e2d43a6a4f3610d0160e135e322709aa57dc22a1d83f"
  end

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
