class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/50.0/gedit-50.0.tar.bz2"
  sha256 "c2d064001b95196f046a6f9705245e3a02dc427265f4e24af9bd2d5f3cb619ee"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.gnome.org/World/gedit/gedit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9d05e61bc6f082489bd0c183cc7eb20067b415a43a7dc49778990e6db91ed9ce"
    sha256 arm64_sequoia: "a42bdc40d34a9f665aa0d266720a698b28a115f7e527e5776f2f14142a55c799"
    sha256 arm64_sonoma:  "651816294d7db144a7c9ae5189ed52d7b030c28a4d755a59965e4934d4a30b9c"
    sha256 sonoma:        "a29b74a068bab86876bcbf911c27c9e8b329c2793de4e88360bb2411807d8618"
    sha256 arm64_linux:   "16b04de90044b42cd9a893b119ddf9f5e8c1b039228cc72ebdaedc4052dfeb0d"
    sha256 x86_64_linux:  "8a4627de62983183afbd42bac7368ab75436e7d1288376d5e15b887b3f8ace43"
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("icu4c")/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libpeas@1")/"pkgconfig"

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
