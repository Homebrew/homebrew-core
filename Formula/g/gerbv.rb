class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "0479b333efffadc118b7e3080be5621d8890fdcd2376edbe40a686d5c3642784"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_golden_gate: "c9f41308438d5a9ebff69e437751772ee790fa627b17d0489855016ccc816fb8"
    sha256 arm64_tahoe:       "788e066539724b16e264114157b1aeb7f250d68fbf26209f563d3b2f615391fb"
    sha256 arm64_sequoia:     "3a0eb6d8a1e72b1b5486a63301f7c34f4ed7e9be7c66b7ea46198d0f720e212c"
    sha256 arm64_linux:       "7a5b0ee767f34240ebc2550311e0e7681fba7a5114b58ef4538dcaf3ce9d6e01"
    sha256 x86_64_linux:      "dd21a26c7492e8897c49bee9fb00c46cb0ee1872184cbcd2af56b54c6d52c995"
  end

  # Can be undeprecated if upstream moves to GTK 3/4: https://github.com/gerbv/gerbv/issues/71
  deprecate! date: "2026-08-28", because: "needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "needs EOL `gtk+`"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  deny_network_access!

  def install
    args = %w[--toolchain cmake/toolchains/macos-clang.cmake] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # executable (GUI) test
    system bin/"gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgerbv").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end
