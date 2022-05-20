class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-3.0.3/jasper-3.0.3.tar.gz"
  sha256 "7c2ae6e10f0e4988277aba9d6d15cbf4f73576e9372c1749366e565b68c76eae"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e635dfd87b1259ba12c7f507dfd8b8d316cb8ede579eb01219601af2a0dd9a9"
    sha256 cellar: :any,                 arm64_big_sur:  "94ece4798dcc13479a719d52684c0c4ab6a26deb8c1331948953d01c6061e514"
    sha256 cellar: :any,                 monterey:       "ad01c6d8f38d4aab1a34c29fd665d4b6f7f68a21b4041ee745ceec15b88e085f"
    sha256 cellar: :any,                 big_sur:        "1e52cfd6893ed868d1041f912ef31b99c7530b002194b57f1905a21cd0f337e2"
    sha256 cellar: :any,                 catalina:       "1a3ce7bc7b60cd9ca3ec7e0d6ee405d6609c84d2fdcfb040f68a1ce3d5e54146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08426c225b8e8ca3d9f3e702380b13aad3d676067ecc64ab449c78fc5962170c"
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
