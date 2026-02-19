class LibayatanaIndicator < Formula
  desc "Ayatana Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-indicator"
  url "https://github.com/AyatanaIndicators/libayatana-indicator/archive/refs/tags/0.9.4.tar.gz"
  sha256 "a18d3c682e29afd77db24366f8475b26bda22b0e16ff569a2ec71cd6eb4eac95"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "da9fc97cc1bb2c19f987eeef759158febcc99007450d7643c712d6e4612600ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "38823b368d0eb88a0cbaff12fe3d6dae2e78ac39092214bad70a290d44ccb7c1"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "ayatana-ido"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on :linux # PR ref: https://github.com/AyatanaIndicators/libayatana-indicator/pull/77
  depends_on "pango"

  def install
    args = %w[
      -DENABLE_IDO=ON
      -DENABLE_LOADER=ON
      -DENABLE_TESTS=OFF
      -DFLAVOUR_GTK3=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-indicator/indicator-service.h>
      #include <assert.h>
      int main() {
        IndicatorService *service = indicator_service_new("homebrew-test");
        assert(service != NULL && "indicator_service_new should not return NULL");
        g_object_unref(service);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs ayatana-indicator3-0.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
