class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/44/gitg-44.tar.xz"
  sha256 "342a31684dab9671cd341bd3e3ce665adcee0460c2a081ddc493cdbc03132530"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "abbdc8fc35ce728c48bbe65c9343d17768755954947cfc919141ea6c7eb0e90b"
    sha256 arm64_sequoia: "4028f294581707bbf199f5ff73c017cf8f038c42624be131fefa85604743f42e"
    sha256 arm64_sonoma:  "685263322a42dacb348f6df3e00a7feb5c1848277e8acd4630e009c29814d324"
    sha256 arm64_ventura: "67c8e9d95c5a1245c3fa87a32a769b63e404926e2a38a18bf769131a3f85effc"
    sha256 sonoma:        "031c605fa3aacbdb1d98191b437836f221d4c25001095f5702664b2374f2472b"
    sha256 ventura:       "09b98443b56e74ddf4c05db0712e2f537e972d27c44f403ad2df856410b0e6e8"
    sha256 arm64_linux:   "88e01965c7dd3989359c8510f8370b9fd0b0bc5e4a746085ae38dbd98f3d16e0"
    sha256 x86_64_linux:  "cc0d17fcf6594d48911e83c12a07c84be0e53b0878ff565b5dcf39baeb63e973"
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
