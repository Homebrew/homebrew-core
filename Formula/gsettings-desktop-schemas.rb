class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/42/gsettings-desktop-schemas-42.0.tar.xz"
  sha256 "6686335a9ed623f7ae2276fefa50a410d4e71d4231880824714070cb317323d2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27eabf5d5e5f619418a2b6be7ca9b42de63572e595ab92e6e8960256ca176c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27eabf5d5e5f619418a2b6be7ca9b42de63572e595ab92e6e8960256ca176c4"
    sha256 cellar: :any_skip_relocation, monterey:       "57cdbf1950a1dea3008b6f4c8ed0a1d7d38a5a9e8cedfa31ca3ac5b4dfbead66"
    sha256 cellar: :any_skip_relocation, big_sur:        "57cdbf1950a1dea3008b6f4c8ed0a1d7d38a5a9e8cedfa31ca3ac5b4dfbead66"
    sha256 cellar: :any_skip_relocation, catalina:       "57cdbf1950a1dea3008b6f4c8ed0a1d7d38a5a9e8cedfa31ca3ac5b4dfbead66"
    sha256 cellar: :any_skip_relocation, mojave:         "57cdbf1950a1dea3008b6f4c8ed0a1d7d38a5a9e8cedfa31ca3ac5b4dfbead66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f6428fc391dda01e161b14a0bd183d340b78cf5cb85a9e66b4ba33be790fa8"
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
