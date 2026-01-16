class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/0.10.4.tar.gz"
  sha256 "bd59abd5f1314e411d0d55ce3643e91cef633271f58126be529de5fb71c5ab38"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d057f3cc3501c6a142003866281a9290c052086decc8167138488d6a7fc906f8"
    sha256 cellar: :any,                 arm64_sequoia: "4fed31960fa9d6d907fb7c6e283573b7a456abce909ed30d88e70bbaa9c88d9a"
    sha256 cellar: :any,                 arm64_sonoma:  "09913ff54d95db83cdacf1f026844761d2973a581fac4c4698ab46b97a7d016e"
    sha256 cellar: :any,                 arm64_ventura: "c415adf102890257e312cbf46e14e274819d513479c51bedef3ec4beb25c517b"
    sha256 cellar: :any,                 sonoma:        "a4633dc9cd30e3ccfb1079a42c91df5fefa6c4cf4e2f70e18a0c1538f9cd7356"
    sha256 cellar: :any,                 ventura:       "8d7ec3123010aa1ff40ff6a84b8369808f5581cd437b6197984157c3b119edfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8908314215b919c26a433bc0c539510a495a209ddd0361aa14cfe0f4f631558c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0462edd4eaed23ad5557e1e733f4fbb17256f850da3c8a6c1f6cff6a9c95f750"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-ido/libayatana-ido.h>
      int main() {
        ido_init();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libayatana-ido3-0.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
