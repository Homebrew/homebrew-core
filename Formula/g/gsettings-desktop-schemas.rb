class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/47/gsettings-desktop-schemas-47.1.tar.xz"
  sha256 "a60204d9c9c0a1b264d6d0d134a38340ba5fc6076a34b84da945d8bfcc7a2815"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e42eec92d68e461084cf34eed8eb1a306213860d6ed4ebabecb9a34aa489fb5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e42eec92d68e461084cf34eed8eb1a306213860d6ed4ebabecb9a34aa489fb5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e42eec92d68e461084cf34eed8eb1a306213860d6ed4ebabecb9a34aa489fb5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e42eec92d68e461084cf34eed8eb1a306213860d6ed4ebabecb9a34aa489fb5d"
    sha256 cellar: :any_skip_relocation, ventura:       "e42eec92d68e461084cf34eed8eb1a306213860d6ed4ebabecb9a34aa489fb5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4804607789ff762c44c3fcc63afea62ed99dcc60782fbd17c5e50e5b5dc714"
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
