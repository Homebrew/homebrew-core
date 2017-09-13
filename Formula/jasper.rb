class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.13.tar.gz"
  sha256 "b50413b41bfc82ae419298b41eadcde1aa31f362fb9dc2ac089e5cbc19f60c24"
  revision 1

  bottle do
    sha256 "8c746481671658374fb0efeba172a138016e36ae67cd26665a8979babc6d0a6c" => :sierra
    sha256 "0d1b7ce6f6c98962a832fc492c4603ab46e15db33bfd6211df5ee1e6d457e413" => :el_capitan
    sha256 "e8c2d8f19672658b0717df280f03132b57c588b7aacf14c44651334be81b09ea" => :yosemite
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
