class Libdecor < Formula
  desc "Client-side decorations library for Wayland client"
  homepage "https://gitlab.freedesktop.org/libdecor/libdecor"
  url "https://gitlab.freedesktop.org/libdecor/libdecor/-/releases/0.2.5/downloads/libdecor-0.2.5.tar.xz"
  sha256 "7fd50f780a4fee90a03f7b2c09055033e488654cbaff4a0c4bbae616bac9cd1c"
  license "MIT"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/18349/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.filter_map { |item| item["tag_name"]&.[](regex, 1) }
    end
  end

  bottle do
    sha256 arm64_linux:  "a33126a6a50cb479b6e6cf78afb9c78993e0d4c32fcaf9a7b0809b74691185e2"
    sha256 x86_64_linux: "615d9589a6c9b46664d33c1f955b29659c09b7503ef0e1ccd7444a400cbcec90"
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
