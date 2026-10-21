class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/51.0/gedit-51.0.tar.bz2"
  sha256 "25070b5c70af1839efab396f03e50caff15262a2e22ff8a550013e2bec84738d"
  license "GPL-2.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/gedit.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "8a5f0c850fb7f16d41490a719670d7a8549de2c8e88be8d23038aebd7300b557"
    sha256 arm64_tahoe:       "507b87e2c995aa2361e462cbeebe7ad53c5be6375a9a3c6d79775bfae5dd6e0d"
    sha256 arm64_sequoia:     "1c78bccbdfe7b63c5e06497610f1cbfc7f195409f2844c36332767ec65dc2d7f"
    sha256 arm64_linux:       "68585fda7bc264c2af6149fa12f2fc7da99761dbda8a3b7429fa4adeaa63c9ab"
    sha256 x86_64_linux:      "b96e101f2a7d9b985bd4bae11c29c5761d801dc2223c49e2345231c76c8e65f1"
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
