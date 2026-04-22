class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/50.0/gedit-50.0.tar.bz2"
  sha256 "c2d064001b95196f046a6f9705245e3a02dc427265f4e24af9bd2d5f3cb619ee"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/gedit.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "7ab23f8b77bacabdc5c44b8dbd1a723d6e3466520ec79efba32c317992b9780e"
    sha256 arm64_sequoia: "37c41e7231cf0347a22679a0e93538a583256f18ec8f6e80e2dacc746b98abad"
    sha256 arm64_sonoma:  "9c557f5e3353b2f47bed28cb382f154ddbe00e9093756e848bf5c9accd5d4fb5"
    sha256 sonoma:        "c0de076352635b54021b8f2071a7b165560bce4d38c71080da5a9bd9a4462420"
    sha256 arm64_linux:   "b67918659a932d7e8773cfce2841874fd440811ec088abefd89da0518901a1ca"
    sha256 x86_64_linux:  "2e2bb9743758ec4e03af79652116c9ed9a52957360bcf9eaea61aecab70b4c3a"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

  resource "libgd" do
    url "https://gitlab.gnome.org/GNOME/libgd/-/archive/c7c7ff4e05d3fe82854219091cf116cce6b19de0.tar.bz2"
    version "c7c7ff4e05d3fe82854219091cf116cce6b19de0"
    sha256 "343abb090461d011dfb1bce5b5da1dfbc9f6c7b6b3223a1b322adb33675212c1"

    livecheck do
      url "https://gitlab.gnome.org/api/v4/projects/World%2Fgedit%2Fgedit/repository/files/subprojects%2Flibgd?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["blob_id"]
      end
    end
  end

  def install
    resource("libgd").stage buildpath/"subprojects/libgd"

    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpeas@1"].opt_lib/"pkgconfig"

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
