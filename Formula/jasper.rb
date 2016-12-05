class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.4.tar.gz"
  sha256 "659a17d9754a2c4786c20ce65bf26309892740e781a512c5da5720a66b372d74"

  bottle do
    sha256 "e7e4544ff2d4a580190694f68ad554eb8d775333b9a6003ae88c047bb66287f0" => :sierra
    sha256 "da795da61aaadbda342072c5e4c9e3c4f20cdfff89c84d662af4c003f30167b3" => :el_capitan
    sha256 "d94a5b12e5536cd437700d5e7cd1de833783b7e7b46db0801247c8058d685d06" => :yosemite
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
