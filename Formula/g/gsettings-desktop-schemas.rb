class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/50/gsettings-desktop-schemas-50.1.tar.xz"
  sha256 "0a2aa25082672585d16fcdab61c7b0e33f035fb87476505c794f29565afa485b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "898b6804a80dcbdd84c7ce0fc1a2fe8068204bcfda38dcee4e85532aeef0b3c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898b6804a80dcbdd84c7ce0fc1a2fe8068204bcfda38dcee4e85532aeef0b3c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898b6804a80dcbdd84c7ce0fc1a2fe8068204bcfda38dcee4e85532aeef0b3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "898b6804a80dcbdd84c7ce0fc1a2fe8068204bcfda38dcee4e85532aeef0b3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3944c3e35f72d75d9d5fc7117cb81e2629d29471995aa4fd49d6421ac4b817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b3944c3e35f72d75d9d5fc7117cb81e2629d29471995aa4fd49d6421ac4b817"
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

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
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
