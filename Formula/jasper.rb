class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.24.tar.gz"
  sha256 "d2d28e115968d38499163cf8086179503668ce0d71b90dd33855b3de96a1ca1d"
  license "JasPer-2.0"

  bottle do
    rebuild 1
    sha256 "4abe374404d02e789f7e368f09ee8b9f85ba0e248e622a24b52ae80d2a51b8b5" => :big_sur
    sha256 "46ce4a32525d202961aef9c382598ddf24f0fb1d1c76e669d47fe2405d09cbe4" => :arm64_big_sur
    sha256 "79c518b587275d3bfb440ee0ece95f143c2241c964ae5c1fb003340f0ff261eb" => :catalina
    sha256 "27c44449772445bef1ad62ebc185f7d1dd7efac480f882a9d0ac398f4e4a74a0" => :mojave
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
