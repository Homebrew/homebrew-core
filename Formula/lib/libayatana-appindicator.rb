class LibayatanaAppindicator < Formula
  desc "Ayatana Application Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-appindicator"
  url "https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/0.6.0.tar.gz"
  sha256 "23be92ad8eb9625ce93b23b14f82f3cf88a4970c31d48581945ddfbac0441d06"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "366cecbce20e7f083e67f236b47cd0e5b92dbb395bc9340ad71a593a4a34e597"
    sha256 cellar: :any, arm64_sequoia: "b2bceade01f2056f4e9ebaec1388c1fbd7d5570365a23b4170d39f88be35204d"
    sha256 cellar: :any, arm64_sonoma:  "5a8120020dd5d6d83fd335c62d1c95c2bcf7a3d70030c7c72dfa168f4023e43f"
    sha256 cellar: :any, sonoma:        "05ebbb9d01f6914521e972dbc92da891281751861f628b9e8938a29a29301689"
    sha256 cellar: :any, arm64_linux:   "c2c991f9220114279f09fd40669993f94d4982453d5b74210e106d908ea46c97"
    sha256 cellar: :any, x86_64_linux:  "bb93763e7e4070129ce61722c2c3bda9e41959ed776a76ff6b82530384a15e07"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libayatana-indicator"
  depends_on "libdbusmenu"

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
