class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.10.tar.gz"
  sha256 "d48193de3b82e7f5792fe933fba2ef6714228de4d904ce98f3d69217ed7a85ec"

  bottle do
    sha256 "7e3ce2081bf45436e633259ebd09a44060b633c8f82564e63b908f897dd4dab0" => :sierra
    sha256 "15c49620b4750b9bb7102799134f6918290048adfdff2545b4dd7c25e7102181" => :el_capitan
    sha256 "7f4fb674c6ffa1d14d5651da60d2a5e20acca9a7abd1e321c385d0cb6e87778d" => :yosemite
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
