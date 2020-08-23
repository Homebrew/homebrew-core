class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.36/gsettings-desktop-schemas-3.36.1.tar.xz"
  sha256 "004bdbe43cf8290f2de7d8537e14d8957610ca479a4fa368e34dbd03f03ec9d9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :catalina
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :mojave
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :high_sierra
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
