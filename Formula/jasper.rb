class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.14.tar.gz"
  sha256 "85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b"

  bottle do
    rebuild 1
    sha256 "ae619b7f71f1b8acc75cb50cb028fafd8d605cbd3f665eeafc73240a716e6e72" => :mojave
    sha256 "ba3837db475f627b3793168dd04dab63997d74e207bfb6908d8e66913393eb5f" => :high_sierra
    sha256 "904647ed12e708f1cfe4f318b992ba7d4545244d4dbbf7e285dcadd5412471bf" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", "-DJAS_ENABLE_SHARED=OFF", *std_cmake_args
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
