class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.38/gsettings-desktop-schemas-3.38.0.tar.xz"
  sha256 "5704c8266004b296036671f223c705dc046aa694a1b1abb87c67e7d2747a8c67"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "abb92dac931cdbbe96c43137c3df3173b41c86565c1053a5578e4b36312de480" => :big_sur
    sha256 "a19a6b6a472566b10ceee4ee1d91c498097cd4e55ed56bfb875cf99e2223cc35" => :arm64_big_sur
    sha256 "0bcc0f743e141beb151ad2b400c40a4d30e317d1080437e359095fb53da3c8e4" => :catalina
    sha256 "dd69129d87fd0b0c435b29b19e2ac9cea2d1a72d557aed9b3db1202afb49578d" => :mojave
    sha256 "63a1370fe1e1e58eabb9e608cb992a8391e2ba11c0940899d4c37c3c43088ff2" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
