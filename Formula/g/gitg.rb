class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/44/gitg-44.tar.xz"
  sha256 "342a31684dab9671cd341bd3e3ce665adcee0460c2a081ddc493cdbc03132530"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "7e0c120472cfb2223b7615d56e431e51a865850aa768160458f27c8b0e8ba30a"
    sha256 arm64_sequoia: "6d64e919f7a876eb31d1f3e21b5d2122a7848d85c7255c58cebc041c2ca0d76b"
    sha256 arm64_sonoma:  "f039601407fbfc1a05514dad5ca9554fc7579b896f0295e96d2600d9f84b1089"
    sha256 sonoma:        "b010e10497311ebb97003411fc0bb89e6ba1f0d65369ce9f7d0a47c6ee99cbd6"
    sha256 arm64_linux:   "175fd3c4967bc7c203ffccf8a49b95c918f238d4c586194131c3f2307c9d38cf"
    sha256 x86_64_linux:  "9367ce2434837207a786ae3faaec0362f577fe08d8820bf02436d0d01ce5572d"
  end

  depends_on "gettext" => :build # for `msgfmt`
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gpgme"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libdazzle"
  depends_on "libgee"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libhandy"
  depends_on "libpeas@1"
  depends_on "libsecret"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3: https://gitlab.gnome.org/GNOME/gitg/-/issues/465
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dpython=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Disable this part of test on Linux because display is not available.
    assert_match version.to_s, shell_output("#{bin}/gitg --version") if OS.mac?

    (testpath/"test.c").write <<~C
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libgit2"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libgitg-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
