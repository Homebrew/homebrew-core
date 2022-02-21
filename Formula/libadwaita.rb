class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.0/libadwaita-1.0.2.tar.xz"
  sha256 "79e56011f5532fba6cb02531249d2bcfb8a6c42495c7a7de92f8819661fea091"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "4912d1df5884d1ac12df98026bf8b9e3bc77493ee682e3852fad7cc1467110e4"
    sha256 arm64_big_sur:  "e356fe20ec6553d912ca7cafd2ab865d3d5f37aaebdc3d88d66258a16ce8224b"
    sha256 monterey:       "aeea3cb18115883487efea75fc0f8318eb6b7272f0815168256c7516d3f8308c"
    sha256 big_sur:        "57cfa283583385ee480fc3cf5b89e2245cab7f4d590ced36929dc7ec4d74720c"
    sha256 catalina:       "c432dd1122cc382263cf78ee3d7db5f7f3cff57b8bb50b7c184ced2ac1a147a9"
    sha256 x86_64_linux:   "3a35ef42ae77db6761be7e0b70930388a03cd9c1605e1b2a89dc0d764c7619f6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sassc" => :build
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    args = std_meson_args + %w[
      -Dtests=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
