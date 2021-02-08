class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.25.tar.gz"
  sha256 "f5bc48e2884bcabd2aca1737baff4ca962ec665b6eb673966ced1f7adea07edb"
  license "JasPer-2.0"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "46ce4a32525d202961aef9c382598ddf24f0fb1d1c76e669d47fe2405d09cbe4"
    sha256 big_sur:       "4abe374404d02e789f7e368f09ee8b9f85ba0e248e622a24b52ae80d2a51b8b5"
    sha256 catalina:      "79c518b587275d3bfb440ee0ece95f143c2241c964ae5c1fb003340f0ff261eb"
    sha256 mojave:        "27c44449772445bef1ad62ebc185f7d1dd7efac480f882a9d0ac398f4e4a74a0"
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
