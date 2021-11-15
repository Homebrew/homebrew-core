class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-2.0.33/jasper-2.0.33.tar.gz"
  sha256 "28d28290cc2eaf70c8756d391ed8bcc8ab809a895b9a67ea6e89da23a611801a"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d81460f695f07a776aed0a304cbf71e32db97d439d2daf3bc4a64d1c2e4d648"
    sha256 cellar: :any,                 arm64_big_sur:  "d3a5b5039c95970e08dc6265aa845e4a4e675987519fd1cfe5ae3990b0b236b8"
    sha256 cellar: :any,                 monterey:       "7f5cd02f1f30c50f98dceafc0f9cc5bbf30bd85667f141e44eef5ceb8ae61af5"
    sha256 cellar: :any,                 big_sur:        "7462315306489ccf06bddad20b9ba97b5872574f8155dfa7f5d316d905da76b8"
    sha256 cellar: :any,                 catalina:       "7c7ae386ed0221d5b04f50b0258afddda977ec8e968f3dcb1e099a1826bb30d7"
    sha256 cellar: :any,                 mojave:         "4c6c520094341ba62068984ed5ee928c992c942d3040956818a92c6a43f26724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f37c44732a8782727150b229ad8dc04bd4f2261b95be05c5d11bebbf197326d"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  on_linux do
    depends_on "freeglut"
  end

  def install
    mkdir "build" do
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
