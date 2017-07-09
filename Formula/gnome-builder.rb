class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.24/gnome-builder-3.24.2.tar.xz"
  sha256 "84843a9f4af2e1ee1ebfac44441a2affa2d409df9066e7d11bf1d232ae0c535a"
  revision 1

  bottle do
    sha256 "5f852460c67649119913b3c5dfc5bfe76b42f191c78e6e8302487ee8baa3025e" => :sierra
    sha256 "a1ccb47ab832c9a088e823c48f70faca7278f19da315f4b11cecb8d38ed93e14" => :el_capitan
    sha256 "fb44801f3fd18316a5cba11573c09993bf5a868df3d58d5a62993690a42c8c53" => :yosemite
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
