class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.24.tar.gz"
  sha256 "d2d28e115968d38499163cf8086179503668ce0d71b90dd33855b3de96a1ca1d"
  license "JasPer-2.0"

  bottle do
    sha256 "d3ec3a84be1bd061d7c64ef8434f126d1e6d6f086d177405b2e8e9c7651dcc79" => :big_sur
    sha256 "638641e641f36d5c48fe361bb5f1096506fb3ce9337c4f15174faf593d8d4a14" => :arm64_big_sur
    sha256 "d1c76e642247f71829a1bfafbff0ddb4f46a11b918299bec64175287033ac90f" => :catalina
    sha256 "1c1317a1ef7c31f8586e98d3fb1604220d7c15a5fd3ccedd5c2cd3bbe0304769" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  on_linux do
    depends_on "freeglut"
  end

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      on_macos do
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      end

      system "cmake", "..",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        "-DJAS_ENABLE_SHARED=ON",
        *args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DJAS_ENABLE_SHARED=OFF",
        *args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
