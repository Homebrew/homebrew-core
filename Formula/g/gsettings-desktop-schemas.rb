class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/46/gsettings-desktop-schemas-46.0.tar.xz"
  sha256 "493a46a1161b6388d57aa72f632a79ce96c42d5ffbd1d0b00f496ec5876f8575"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, monterey:       "0cf5db7c142d6769c09befe16e21caed32f43595367752be53141fd8b0820f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46a1417763d1a1f38479e75934ba374a08f44ba12b84680b20c570f06802083"
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
