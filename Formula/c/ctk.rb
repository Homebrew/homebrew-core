class Ctk < Formula
  desc "Support code for medical imaging, surgical navigation, and related purposes"
  homepage "https://github.com/commontk/CTK"
  url "https://github.com/commontk/CTK/archive/refs/tags/2026.08.06.tar.gz"
  sha256 "e2d8376b2b1644ec7112d4779549cf96cb486e671f1cb6f00ac0e3f27f1379ae"
  license "Apache-2.0"
  head "https://github.com/commontk/CTK.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "itk"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "qtscxml"
  depends_on "qtsvg"
  depends_on "qttools"
  depends_on "qtwebengine"
  depends_on "vtk"

  def install
    args = %w[
      -DCTK_QT_VERSION=6
      -DCTK_SUPERBUILD=OFF
      -DCTK_INSTALL_LIB_DIR=lib
      -DCTK_INSTALL_INCLUDE_DIR=include/ctk
      -DCTK_INSTALL_PLUGIN_DIR=lib/ctk/plugins
      -DCTK_INSTALL_CMAKE_DIR=lib/CMake/ctk
    ]
    # Upstream default: "lib/ctk-0.1", "include/ctk-0.1", "lib/ctk-0.1/plugins" and "lib/ctk-0.1/CMake"
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ctkLogger.h>
      int main() {
          ctkLogger logger("org.commontk.test");
          logger.info("OK");
          return 0;
      }
    CPP
    flags = shell_output("pkgconf --cflags --libs Qt6Core").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}/ctk", "-L#{lib}", "-lCTKCore",
           "-o", "test", *flags
    system "./test"
  end
end
