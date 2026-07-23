class LibayatanaIndicator < Formula
  desc "Ayatana Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-indicator"
  url "https://github.com/AyatanaIndicators/libayatana-indicator/archive/refs/tags/0.9.5.tar.gz"
  sha256 "73d71c908b803f12e4a5ecd8392511b58afbdd0c82ad7909611a17bb7847c5c8"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8a0b1232e8286fdfd594d28265f9abcf1a34fb072e092c1039fe7f5ae16b43ac"
    sha256 cellar: :any, arm64_sequoia: "39b911c2dde3c755f012186cd0407d768df3b559d9ebf31445a0e55dd3018dda"
    sha256 cellar: :any, arm64_sonoma:  "eaac58be65a31c92df88b5921bd8ae935306eb80561336591aafd814417d6d02"
    sha256 cellar: :any, sonoma:        "34fd9878b314e332ac13684560479f5aa64b60bea29602cff93f86151fd7ef0e"
    sha256 cellar: :any, arm64_linux:   "3dde14db9845cc2e58a511355f08d1ea8ec4b021e1adb0a582280fe17d07234d"
    sha256 cellar: :any, x86_64_linux:  "3e040ae1a0fea59df64f5ccea4fd2d2f5a1b6b42fe42481a89b77783b01c7d66"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "ayatana-ido"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    args = %w[
      -DENABLE_IDO=ON
      -DENABLE_LOADER=ON
      -DENABLE_TESTS=OFF
      -DFLAVOUR_GTK3=ON
    ]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs -Wl,-rpath,#{rpath(source: libexec/name)}",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

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
