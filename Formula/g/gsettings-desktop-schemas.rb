class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/45/gsettings-desktop-schemas-45.0.tar.xz"
  sha256 "365c8d04daf79b38c8b3dc9626349a024f9e4befdd31fede74b42f7a9fbe0ae2"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, ventura:        "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, monterey:       "4fca0573983e235860f8628a6718c63f3a804c7a7744d017f67041ea46876abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092735996f7814e3609a156d28054edc5463a1aa54b87a17126db77a4a31424b"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
