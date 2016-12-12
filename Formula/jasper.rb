class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.8.tar.gz"
  sha256 "ebaca7b4bb2354c58f649c6d97d07f14292df31666a7cb29f2b4a066976535e4"

  bottle do
    sha256 "59a1cc4e64289336d7e6fd5bb27be48b2fca3e02827c0d100265c32b25470fd8" => :sierra
    sha256 "2d0b8db56c470c69c49d7a10b31c8c869ba6bf5fbcaae3721ea9f7a22bf9d91d" => :el_capitan
    sha256 "e456b06a64bd2f743d4581530c4da2a209327bdb6f53f811006968a2a60ec3f5" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    ENV.universal_binary if build.universal?

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
