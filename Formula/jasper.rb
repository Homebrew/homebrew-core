class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.9.tar.gz"
  sha256 "873c436fa302b0de10e45df4eef567520414b98ba6e29e41a3fb998d2c26cd54"

  bottle do
    sha256 "c35e8e29c9114057c4f678d7435688dd74b67f0030841fecca69a68ce113eab1" => :sierra
    sha256 "d8686f2a7b8e4099e467a5903b62071dbfb62f3045d6e7375692f952237f5087" => :el_capitan
    sha256 "9ecccefc7c5f115b5e0682fcbb89008d2f8017a2e1dba57f5f18702600117563" => :yosemite
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
