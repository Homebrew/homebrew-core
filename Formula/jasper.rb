class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.12.tar.gz"
  sha256 "f0bcc1c4de5fab199f2e792acf269eb34d54689777c305d80e2498788f9f204b"

  bottle do
    sha256 "dbeca94ef311936f67bec39745d9d6b029f615ea64782cddeaf8601e5da00a28" => :sierra
    sha256 "02602107427e79a874c3b76bacd3fa420b2939d774a512923dc0d3ebf775a247" => :el_capitan
    sha256 "171e40a07a30f42f9a0b3b222bfeb68eaa8623891774c34b81a4fa3d1d143a66" => :yosemite
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
