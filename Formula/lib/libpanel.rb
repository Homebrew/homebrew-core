class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.2/libpanel-1.2.0.tar.xz"
  sha256 "d9055bbbab9625f3f5ce6d1fd7132eb6ea34a6ba07a87e9938901fb8b31581e2"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "ab78fc35ab586e5aea85da26354f3564884611610d918bb172799ae1e1ec001a"
    sha256 arm64_monterey: "475af6d89041310ad2bb8cc77b50384f81d316a4e896cc0cb0bd51ce0c936b88"
    sha256 arm64_big_sur:  "da26973d51a93ca6304ab634d31c03b4ec8f20fd936638cac9d8afbce4e39b6d"
    sha256 ventura:        "834f5e12eafc6af27cab7cb77132919510ce75ba3302b0f9c1e91fbb8ac839e3"
    sha256 monterey:       "bea4ce7bc724fd8509e6a4348bc64904b40ffe7919d5dee51a65efcf45ad743b"
    sha256 big_sur:        "dc0e8ebb1461f52c6a6f3f9f48bcbafdaa6454b8e5e8f510ca1eeb572d574244"
    sha256 x86_64_linux:   "716761f1b41718a3cc393f361e7b50acf17edd52e3381eeebaa3d19d51b97c1f"
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
