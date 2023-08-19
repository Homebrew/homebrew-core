class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.0.0/jasper-4.0.0.tar.gz"
  sha256 "39514e1b53a5333fcff817e19565371f016ea536c36fd2d13a9c4d8da8f0be0c"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a24af85ebb8fadcbbb9be24fbc7c715fbe31441a768f1094e066e6056631424c"
    sha256 cellar: :any,                 arm64_monterey: "6c01e7edfbfeb8d423495c13926294f756069c713acc6a847c52ce75a1598833"
    sha256 cellar: :any,                 arm64_big_sur:  "58cb808658f93bd80b37bc1926a42ed7dd5bc8778c30693d6631d88dda2d701d"
    sha256 cellar: :any,                 ventura:        "24dd3e8e090217621d776b310930468b92e7fb4ce1af7c1971103102aaac452e"
    sha256 cellar: :any,                 monterey:       "81f52cc0adf0bfaf6d5274fadcba9483ed52ae814452af22147709f111e2b4ec"
    sha256 cellar: :any,                 big_sur:        "637581823b9568caaa9eb6ddfc59d469c7ec1968c0ef3feab9e3d93a36e0bca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f9e9ea0014f9965ff66dc114c31b1077197c8157442c167af890c6b27d72c3"
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
