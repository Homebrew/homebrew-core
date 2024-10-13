class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.8/libpanel-1.8.0.tar.xz"
  sha256 "5a9b6b54452fa1903a2fd64ba62278ef94b9b11659b7e1a5fda3518b66cd39c3"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "d60a9681f5e87af264858e1b7d55cc5301343c5bc7c820a640e6baba75f6ad5d"
    sha256 arm64_sonoma:  "0960abdc887edcee2f3158773c505af8d5be48b139cc74ff52037584a65f8b41"
    sha256 arm64_ventura: "7b807b273e98487c3b8da9e80bd02efda63599d341143537466fb7154b367859"
    sha256 sonoma:        "182d6f9edb6bf1f96aeacb116f27d5e9d367565dbace4c38d3f15d45a983cd1b"
    sha256 ventura:       "f8ada60487dd14a53b883ac267d225e165bb0ed749cb8ec667059496f3c5ae80"
    sha256 x86_64_linux:  "66c76f079b76700df240f9faca3df2611a02d332aa5cdb6aa682db85cf179a71"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gi-docgen"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpanel.h>

      int main(int argc, char *argv[]) {
        uint major = panel_get_major_version();
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libpanel-1").strip.split
    flags += shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libpanel-1.pc").read
  end
end
