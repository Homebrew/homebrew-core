class LibayatanaAppindicator < Formula
  desc "Ayatana Application Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-appindicator"
  url "https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/0.5.94.tar.gz"
  sha256 "884a6bc77994c0b58c961613ca4c4b974dc91aa0f804e70e92f38a542d0d0f90"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "253407ddf4628cd2a8c9343aa35df588d239bff65dff68779078e8ad93851ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "589e5c203dbcf5befc48f6e13e0e2e723312ceb2f59b65c7490b6f2e80587dab"
  end

  depends_on "at-spi2-core" => :build
  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libxml2" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "ayatana-ido"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "libayatana-indicator"
  depends_on "libdbusmenu"
  depends_on :linux # libayatana-indicator requires gio/gdesktopappinfo.h which is not available on macOS
  depends_on "pango"

  def install
    args = %w[
      -DENABLE_BINDINGS_MONO=OFF
      -DENABLE_BINDINGS_VALA=ON
      -DENABLE_GTKDOC=OFF
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-appindicator/app-indicator.h>
      #include <assert.h>

      int main() {
        AppIndicator *indicator = app_indicator_new("test-id", "test-icon", APP_INDICATOR_CATEGORY_APPLICATION_STATUS);
        assert(indicator != NULL);
        g_object_unref(indicator);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs ayatana-appindicator3-0.1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
