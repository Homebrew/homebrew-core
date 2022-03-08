class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-3.0.2/jasper-3.0.2.tar.gz"
  sha256 "8b823a5354812c3be36a8e5a1b5b34a281bdc0e73f38d3c9a86303ee9e3cfbd3"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7f5983e4f88c149e5fa38dbeb162e2e1924035d2a088487b04769bdc3826809"
    sha256 cellar: :any,                 arm64_big_sur:  "8adaea7ef3954878bf55f587b91e637d45650209ff72e63870615bfefd3d3a78"
    sha256 cellar: :any,                 monterey:       "78bdc025dddc46d04ab8ccc1d9be3902d28ef56aa4a532ae7c8567bc5fd5a9f2"
    sha256 cellar: :any,                 big_sur:        "441e89fac20bb2247eac97c25d1012e703b6efaa19b47c69f749ba20ba9ca965"
    sha256 cellar: :any,                 catalina:       "8c46069a65f2247ab46ad8d43a02bffd7000c199a1bf3df023b76ac01ba2c3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eff44eb2f9507f7457f6cefc1c84f49922b45f8c2cc4b67a5faba9b8c095b9a"
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
