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
    sha256 cellar: :any,                 arm64_monterey: "e92eecd1478ee734bf479c12e92e32b5f141cfdc7a3be3148b68b16099bcaaf3"
    sha256 cellar: :any,                 arm64_big_sur:  "4fe7c8c23794a3011da1dd520f3d9daf901bcb0321988637ef8cd18bef48d5a1"
    sha256 cellar: :any,                 monterey:       "94b35b14525304d3d84536acdf5c65761ee845b677941eca7436e1d43925afd5"
    sha256 cellar: :any,                 big_sur:        "caa01dda13c0f785cca7c8905d312de9b9e6c39be6f5cb00e5ba6401aa95af8a"
    sha256 cellar: :any,                 catalina:       "399b97f2635bc8f1b6fd6d805ad97adfe7e558bc468ec03c7cd76a20b8cac25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cef9628e900073a31b6f7b8794ed1be8821048e0bad39cc3e192222ef3c16ba5"
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
