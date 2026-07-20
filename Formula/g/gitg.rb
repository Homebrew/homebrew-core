class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/50/gitg-50.tar.xz"
  sha256 "331216a86920cd4e8ab9b0036e63cecb3e1a1d1162c61aa31bd6924e985a8154"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "758cebd9f9840d9442de01e5a2bc5e81578a8c64e138f58b239059e886554328"
    sha256 arm64_sequoia: "08f44f87de55735b7c2fc3d1b746f5665424272c989ff4ee36daf7687a6d9d4d"
    sha256 arm64_sonoma:  "a0ff5c6d15c3888ed58cb2e48e0596991ea7935174d89038c7b5dff4931654a3"
    sha256 sonoma:        "225d5ac61e02754ebcac9aac3fd1791dcea6722a287fd0bb5a869249b6e43190"
    sha256 arm64_linux:   "70ebb27ddc945b5bcdb1f016383363dc190deaf90f5445e9b0aa44ae5ba1e49a"
    sha256 x86_64_linux:  "915657a8a8e1ce9b86adfd7b8397ccf41e915166c5180d6b28b794b3028173e9"
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

  # Fix build with newer GCC rejecting an invalid ESC universal character name
  # PR ref: https://gitlab.gnome.org/GNOME/gitg/-/merge_requests/410
  patch do
    url "https://gitlab.gnome.org/GNOME/gitg/-/commit/22db29e9069042b4e5c07ee496c62c8c63e9b7d5.diff"
    sha256 "570f15ebcf61ff7779ad638120a6542b0f045272c77a5b185a27d2c50f2d3a18"
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
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
