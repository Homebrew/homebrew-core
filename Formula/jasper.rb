class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.28.tar.gz"
  sha256 "6b4e5f682be0ab1a5acb0eeb6bf41d6ce17a658bb8e2dbda95de40100939cc88"
  license "JasPer-2.0"

  bottle do
    sha256 arm64_big_sur: "fb802e00f7ca863770a02f6415b84a3291886b18dcfedd89c8069426e7a80d8e"
    sha256 big_sur:       "62a84ae4413026c3ccfe5b176653f1bd4465144ee06d72464111acef0e4e2d7a"
    sha256 catalina:      "02b558ef5d6d3b9226a351e45733a1e2c3688d427ef94e58b34401bdbd42ed0f"
    sha256 mojave:        "ff2515782e4af67a5fbd094f91bb6ab1c224188ad09742a917a10f83c8184eae"
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
