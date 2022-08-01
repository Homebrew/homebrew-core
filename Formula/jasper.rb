class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-3.0.6/jasper-3.0.6.tar.gz"
  sha256 "169be004d91f6940c649a4f854ada2755d4f35f62b0555ce9e1219c778cffc09"
  license "JasPer-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c8f086fe1649d27b4c0be5b5bcfd327a6f12b34cc77aa2b3eedb80c3d0b4e16"
    sha256 cellar: :any,                 arm64_big_sur:  "dcdab9d270f1bca6a4ed051e0066c151a9af509c6c57eca5cf67d247cd80adba"
    sha256 cellar: :any,                 monterey:       "8b646454b4333ef3560dd64e5dd79d71aa966019083be54fa6ac53ef89f47cfe"
    sha256 cellar: :any,                 big_sur:        "5b46bdd3bbce39c5c2a0134ecae52d52135af33fdf73ee6bb8d33b0aa8e561fd"
    sha256 cellar: :any,                 catalina:       "db95321eda1aa0ac95e55ad0054136df530ae86d30c5acf007450881eea09894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd28bd1233a4be70ba6f3c025eb71b2fa72d5c23fb356088280145f5b128c6c9"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    mkdir "tmp_cmake" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      if OS.mac?
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      else
        args << "-DJAS_ENABLE_OPENGL=OFF"
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
