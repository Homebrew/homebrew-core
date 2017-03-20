class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.24/gnome-builder-3.24.0.tar.xz"
  sha256 "3c2948f451dd107b3838bd6580bd7df95aa455d16f595aefab6e7553cccfc8d2"

  bottle do
    sha256 "7de45091638dcc78c6a8e7857527cf49d5f25087029e18181c852d0ba981250f" => :sierra
    sha256 "b50cb8c9c4de8377b687fc5cc8fddb521c6a4efec96804e20874dd861cddd441" => :el_capitan
    sha256 "0c7e34722c5194f2cee31a543ea135350fbb5add06a75d377e5400e87d39e532" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "coreutils" => :build
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libgit2-glib"].opt_libexec/"libgit2/lib/pkgconfig"

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
