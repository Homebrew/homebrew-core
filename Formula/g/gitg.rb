class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/44/gitg-44.tar.xz"
  sha256 "342a31684dab9671cd341bd3e3ce665adcee0460c2a081ddc493cdbc03132530"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "41fe2e32ec7285168a5ddc42e5ea5d1c2f8e754e96e2ed14b23b4bc535dcbf33"
    sha256 arm64_sequoia: "3d5c60e8a49d2a0af425ea4927666d587cd923305625eb31ab762d60dc8f40a3"
    sha256 arm64_sonoma:  "6e17e52112c02ea6a3e398cd175840a7c684837c6fef392b4e08a1c4a3d99f70"
    sha256 sonoma:        "00214501c8d98397ac9e1dbe67a2c72c4a697e1016a44557d9485cb28267306c"
    sha256 arm64_linux:   "edd407c606f84337f4b3a980232199c2b13c80fede622f43035c864c1c5efe9e"
    sha256 x86_64_linux:  "6f55ce2297cbc4c5a3234586eadf7cd349599fb8ad8053a9550688a3a1f85351"
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

    # Drop girepository-1.0 typelib loading (Python loader only, disabled here)
    # as it conflicts with libpeas 1.38's girepository-2.0.
    inreplace "gitg/gitg-plugins-engine.vala" do |s|
      s.gsub!(/\t\tvar repo = Introspection\.Repository.*?\n\t\tcatch \(Error e\)\n\t\t\{.*?return;\n\t\t\}\n/m, "")
    end

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dpython=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{formula_opt_bin("glib")}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{formula_opt_bin("gtk+3")}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libgit2")/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libgitg-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
