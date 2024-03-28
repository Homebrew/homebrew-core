class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.6/libpanel-1.6.0.tar.xz"
  sha256 "b773494a3c69300345cd8e27027448d1189183026cc137802f886417c6ea30b6"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "f128a9f64a77bf5cd52335cf1bdbca30d5c5d72c4ab50db59381817e63b2e199"
    sha256 arm64_ventura:  "2690f378bfe0dca66e25e5ba37df69c79059fca808fb4a33e1e4a0a11883da17"
    sha256 arm64_monterey: "db427b5bd6ec77fe44a009b73b6a8b4a05c038674177f370a274bf0b221b5b9e"
    sha256 sonoma:         "2184f1d539a8861ef0dc83942b0c57aa61747a2f1deea7f634eeecec623b8f44"
    sha256 ventura:        "aadc359a7f15b4c3b2dffd9080e7a60d9358daa00c912cad5544b05566aefc75"
    sha256 monterey:       "473b09c921351aa3de20e02546b2eadc395f91291fab6a5df01911b82896851d"
    sha256 x86_64_linux:   "3fc32643880bc018a9f829ebbf34038b66ba5231c333fcaa956a8b5289e06ff9"
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
