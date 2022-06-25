class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-3.0.5/jasper-3.0.5.tar.gz"
  sha256 "3e600d98f41d3b08124bd24c558ed0c171fe5fd705fa90d56baf2b814c58483a"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc677ea04e1d617278a2e2c1333e1428d6c3f3b01ece71aa765627c404b57fe9"
    sha256 cellar: :any,                 arm64_big_sur:  "c8b902827a015ee9bc53cfd58da2726da109186bb91e4fab0286f4d74e0cf683"
    sha256 cellar: :any,                 monterey:       "c8229227691aa57fd325705c4da1510c1ead41e6350cd45aaef033bbbd5eb1ec"
    sha256 cellar: :any,                 big_sur:        "bdb4562775bd2fef32696ed4f535aa718ab1bfb0cb4aabd3cf756aabfeda99f9"
    sha256 cellar: :any,                 catalina:       "69bb474ce202311f77b67556d36a1fa76302934c3015a8f19f2cbce066277f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82ae0394fc150bad2f801a4ead62873a3276753fc585b697eb13c0efd4e442c"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  on_linux do
    depends_on "freeglut"
  end

  def install
    mkdir "tmp_cmake" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      if OS.mac?
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      end

      system "cmake", "..",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        "-DJAS_ENABLE_SHARED=ON",
        *args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DJAS_ENABLE_SHARED=OFF",
        *args
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
