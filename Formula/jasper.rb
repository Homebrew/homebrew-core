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
    sha256 cellar: :any,                 arm64_monterey: "ce501597080cc65d188fffcc47ee0b875c93c8aee7ca16ea6489b43962a872bf"
    sha256 cellar: :any,                 arm64_big_sur:  "e4d89764c72ab0a57ed1589dae571175d06975c209fc7413b99bf69b2773fa3c"
    sha256 cellar: :any,                 monterey:       "b2171d7330a2afe7e751adb95821d25b4d399d5013effd8f2a8b5f5af4e68e85"
    sha256 cellar: :any,                 big_sur:        "9d5963f00658ae5bf0c03960d824c72f9fd16e9dff257a763155847e68bed686"
    sha256 cellar: :any,                 catalina:       "fb7e2d288f479428de29c66069709eeb77488f6efa91082243103e8ce04576be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6c116a402d57678ab637b9a60c8cbaef9a94f127ea9770248f73e02e7409d0"
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
