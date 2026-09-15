class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/51/gsettings-desktop-schemas-51.0.tar.xz"
  sha256 "1e2419a5f21d26c324b28ae1c00e29e9175e8b596fff385a04c2172b36652226"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d70b0494de9d764c4f893a22f75a736aa97b8de37b9de51da36a0789f134f1a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d70b0494de9d764c4f893a22f75a736aa97b8de37b9de51da36a0789f134f1a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d70b0494de9d764c4f893a22f75a736aa97b8de37b9de51da36a0789f134f1a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81a6ecb2ebe3b359bd024462b2d780ea5c346c9cadc10cada13f33de87fe2db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "81a6ecb2ebe3b359bd024462b2d780ea5c346c9cadc10cada13f33de87fe2db3"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    C
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
