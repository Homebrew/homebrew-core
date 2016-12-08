class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.5.tar.gz"
  sha256 "77478d80bef35616ca554924d719922064343cdc5b6f5223a2a4118c9afe535d"

  bottle do
    sha256 "23f593c142747d5d33b4b1f0dd0cc7ca672c6a1aaefbc5a14ad0958f4ee40cc5" => :sierra
    sha256 "d6015aa811ce2f85f196ab0aae862301d620dd6c943fd3d6b6ca174c69db6d84" => :el_capitan
    sha256 "4ae25d7f3e30d5ac6228dcbc174d24da486cf0c0d5fff49af9cc61316dd8ce9c" => :yosemite
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
