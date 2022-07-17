class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-3.0.6/jasper-3.0.6.tar.gz"
  sha256 "169be004d91f6940c649a4f854ada2755d4f35f62b0555ce9e1219c778cffc09"
  license "JasPer-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c7bef3615895f3bc6fb09be8ddae9f4ef8adcabe0757e5e95c169baa11999098"
    sha256 cellar: :any,                 arm64_big_sur:  "c92d6874448be87a992df9990dab202273c9076c1b27c7873f3a78cab0c3a42a"
    sha256 cellar: :any,                 monterey:       "a9ef5ac4a7802f95b6e5a6f9fd49dac46c1638976df4296505187f76a27f7947"
    sha256 cellar: :any,                 big_sur:        "46813e405d13c8739401f1262930e4d9b29bc40f6c62df787d4ae0bcb13e6386"
    sha256 cellar: :any,                 catalina:       "73a69e1a566f47558383b0d29a12ec85fa32fc0fbccfa2ad178af047ec42dfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09871c2ed1855772d717206ed7a674bdfbfd31a523a41c8a170f8c0d91d06908"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

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
