class LibayatanaAppindicator < Formula
  desc "Ayatana Application Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-appindicator"
  url "https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/0.6.1.tar.gz"
  sha256 "56c0b938ffaa3e17b10c38d3e54c16d316f41f0da61949eda028adbf19ee767f"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e3eac516a9e3878cd19e20e46911dde52d7d15f6db4fa061a1171cb1cd6e110b"
    sha256 cellar: :any, arm64_tahoe:       "605044d0ec62a727d5796ffe08433eb5a341211c59fb57695c11d66276217d50"
    sha256 cellar: :any, arm64_sequoia:     "4dfd293942350c5d24b0cd64747b74de9395b1b1f0df87f793f9dfb167e6e6ca"
    sha256 cellar: :any, arm64_linux:       "a8455328b661be5a2c5cd3a2a40c7e3e9fe8d2b0f6b4fce9fac6ea2a0c21b390"
    sha256 cellar: :any, x86_64_linux:      "ad5b20707211e2fc2ab7d009d94527f35028f595491b333036443dc3cbc517e0"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libayatana-indicator"
  depends_on "libdbusmenu"

  deny_network_access!

  def install
    args = %w[
      -DENABLE_BINDINGS_MONO=OFF
      -DENABLE_BINDINGS_VALA=ON
      -DENABLE_GTKDOC=OFF
      -DENABLE_TESTS=OFF
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
