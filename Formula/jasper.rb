class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.8.tar.gz"
  sha256 "ebaca7b4bb2354c58f649c6d97d07f14292df31666a7cb29f2b4a066976535e4"

  bottle do
    sha256 "bc352da5126c3b91d0e301aae1fdbed5759e6de6dacced81d83043cc10c01a6e" => :sierra
    sha256 "10e2f055bd0b28529ac74282feefab48af9c73cd64fefceabae7ee72c658bb8a" => :el_capitan
    sha256 "f64455f21bf00a0663f10176466d83991f9b88deaf28a9a162f4d9a708d704ac" => :yosemite
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
