class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.17.tar.gz"
  sha256 "9a3524aa17795ea10f476d7071e27dd9fc0077d9ffbf2ea49b9f18de0bfe7fa1"
  license "JasPer-2.0"

  bottle do
    sha256 "c4757635256d384f701271d00e5bfd868c4e5dd55b22c3577da74f15fd46f63e" => :catalina
    sha256 "a71be5bd479b1b094f1afaca23e0ff36227427fe98a6229d6cb070efa2eab571" => :mojave
    sha256 "cc78383e32b4c1c7da27d1ab08da9d779e6752ba9696f0b20069541ce69f70f9" => :high_sierra
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
