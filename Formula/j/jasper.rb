class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.2/jasper-4.2.2.tar.gz"
  sha256 "5e397570b3110a8edef6d50127e20a2297939809cea25d29068823b442ecdd6d"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d663da2369666ed025b78d81713ff907175a4be89ad6bb2ac9675707d5fe84f"
    sha256 cellar: :any,                 arm64_ventura:  "3700b682dbfa05a3ce83eb04e46c837b4a53e79c647f15324779658148edb8e2"
    sha256 cellar: :any,                 arm64_monterey: "b36dba5b0ab5c9680174560668474ff0e37cb08ac89c775c53f0286121581d25"
    sha256 cellar: :any,                 sonoma:         "d62aef7cd86be9820266ce2e38952fd290359d9ed1ff5b39f9dde246931856d3"
    sha256 cellar: :any,                 ventura:        "9e3862f819e9aaf80422245363bfe5ce71e22135ef2870955c6ccf155d43d7db"
    sha256 cellar: :any,                 monterey:       "30984805afb02c480f553a5ee410515d31c924c2541e053fe03f890aa6b9e285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9172912ba2f8aa351053a2bbf339651413d7fb3374626b44e1a982098438c2a"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    mkdir "tmp_cmake" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      if OS.mac?
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      else
        args << "-DJAS_ENABLE_OPENGL=OFF"
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
