class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.6/libpanel-1.6.0.tar.xz"
  sha256 "b773494a3c69300345cd8e27027448d1189183026cc137802f886417c6ea30b6"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "120b4c621c892fde5c6ca6982f110dd132183bbef076eefe6d526ec0024d1ee3"
    sha256 arm64_ventura:  "9ec9352b07954b6f0eec5d93edb45c5d75843e48740cb45ecf2899da27029ccb"
    sha256 arm64_monterey: "d13b7481537236142611a235349c53896b496615ddbe4f167aef28139274ff84"
    sha256 sonoma:         "c375c1347d3f9eda58a35c04b8ed30044131a45902b237a0a775040757666a37"
    sha256 ventura:        "a89e901c96af5e75b8a8459add6255fecb172c60ef9014b722b6170c8d280cb0"
    sha256 monterey:       "f444f4da57f81ad818157adc7c5b5b4f8e06fff8dbeccbc73c4425502c222b0a"
    sha256 x86_64_linux:   "d12b946e63caaef9c24b81b07e74e0a5b612337241aceba3511681b2aeb580a1"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gi-docgen"
  depends_on "gtk4"
  depends_on "libadwaita"

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
