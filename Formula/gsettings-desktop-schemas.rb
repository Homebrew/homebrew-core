class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/40/gsettings-desktop-schemas-40.0.tar.xz"
  sha256 "f1b83bf023c0261eacd0ed36066b76f4a520bbcb14bb69c402b7959257125685"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f98030c66d5023f9fd91a7700dff2372a9becd02514bd291139d56c32b2c06c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7f5b4fc71c5dfdd9418823c6252872b6e6ecc7bab2e5828dcdcf7d484223178"
    sha256 cellar: :any_skip_relocation, catalina:      "24379b6ab7c18f2d682d59ef7c8f94eaf67a41d0ed3156deb5f0f9bc99919cd4"
    sha256 cellar: :any_skip_relocation, mojave:        "1350e64db550d9db2f48be5495f4da335b324b9b6c87ce4f073cf52cdbe3f790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8941cdf3c463cbca6ab9028533fd0da7f31ffb05fc0c563ea0ff7811c1fcf6f"
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
