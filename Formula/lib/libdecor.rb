class Libdecor < Formula
  desc "Client-side decorations library for Wayland client"
  homepage "https://gitlab.freedesktop.org/libdecor/libdecor"
  url "https://gitlab.freedesktop.org/libdecor/libdecor/-/releases/0.2.4/downloads/libdecor-0.2.4.tar.xz"
  sha256 "b17cf420e8dcb526bf82da5d36f8443a91fad0777083fa4ec5c1df8ee877416f"
  license "MIT"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/18349/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.filter_map { |item| item["tag_name"]&.[](regex, 1) }
    end
  end

  bottle do
    sha256 arm64_linux:  "0ce1db47f5f6e33e2eb9e56441bfd76e0743d3d73fe36ec03fc70706546e1c0b"
    sha256 x86_64_linux: "01ed6ba19998c4ec2aa7093b943d75a8c491616c0a3638779c7297e4da276ea1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "dbus"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on :linux
  depends_on "pango"
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    system "meson", "setup", "build", "-Ddemo=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdecor.h>

      int main() {
        struct libdecor *context;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/libdecor-0"
    system "./test"
  end
end
