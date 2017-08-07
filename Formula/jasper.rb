class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.13.tar.gz"
  sha256 "b50413b41bfc82ae419298b41eadcde1aa31f362fb9dc2ac089e5cbc19f60c24"
  revision 1

  bottle do
    sha256 "15b83ba35f6bb116b22355c6b72b4b7a88a1d0e1b503a9ec5ef0c1a2450e2952" => :sierra
    sha256 "84ad4c94267c7f8ed61f97677cf298097b5665db77ca4163ece2902d05c2253f" => :el_capitan
    sha256 "02dd0dc3dedfb56d14e806ecb06b2d2c8ee16594b227ad717166b61b9115b879" => :yosemite
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
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
