class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.16.tar.gz"
  sha256 "f1d8b90f231184d99968f361884e2054a1714fdbbd9944ba1ae4ebdcc9bbfdb1"
  revision 1

  bottle do
    sha256 "59750e85fe924ee3c1a8e327794a741b909e4aac2b6d1446db1cbdadf039d317" => :mojave
    sha256 "1aedb239b48d2111e75015d347126432af236243ca0b89efca136507abe0dd13" => :high_sierra
    sha256 "dcc8d4289055c0fc3e13ab94b24cfb4fa8b0c2dd97f2642d712301d1ce03df20" => :sierra
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
