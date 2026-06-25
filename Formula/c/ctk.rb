class Ctk < Formula
  desc "Support code for medical imaging, surgical navigation, and related purposes"
  homepage "https://github.com/commontk/CTK"

  url "https://github.com/commontk/CTK.git",
      revision: "5056664a20a3d0a393bb6d91f040525581e0dcdf"
  version "0.1.0-5056664a"
  sha256 "5056664a20a3d0a393bb6d91f040525581e0dcdf93bb6d91f040525581e0dcdf"
  license "Apache-2.0"

  depends_on "cmake" => :build
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
      -DBUILD_TESTING=OFF
      -DCMAKE_BUILD_TYPE=Release
      -DCTK_QT_VERSION=6
      -DCTK_SUPERBUILD=OFF
    ]
    system "cmake", "-S", ".", "-B", "builddir", *args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~C
      #include <ctkLogger.h>
      int main() {
          ctkLogger logger("org.commontk.test");
          logger.info("OK");
          return 0;
      }
    C
    system ENV.cxx, "test.cpp",
           "-I#{include}/ctk-0.1",
           "-L#{lib}/ctk-0.1", "-lCTKCore",
           "-L#{formula_opt_lib("qtbase")}", "-lQt6Core",
           "-o", "test"
    assert_match "OK", shell_output("./test")
  end
end
