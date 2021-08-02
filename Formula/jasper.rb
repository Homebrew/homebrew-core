class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://github.com/jasper-software/jasper"
  url "https://github.com/jasper-software/jasper/releases/download/version-2.0.33/jasper-2.0.33.tar.gz"
  sha256 "28d28290cc2eaf70c8756d391ed8bcc8ab809a895b9a67ea6e89da23a611801a"
  license "JasPer-2.0"

  livecheck do
    url :homepage
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_big_sur: "b3d001bfed26a9aba810a8b65ef0ccd01500d81afefca702c202f809c7e0fc24"
    sha256                               big_sur:       "3b56f3d1d584df4483b5d35d5d75235bd621201ae7678f58d624b86f523ab6d2"
    sha256                               catalina:      "fce68cb17b6de9af96e493e97091bd4679701884da4f2f413ead6985f511497d"
    sha256                               mojave:        "5e9f20212c7caa5aafd9f12ee56d1e73d179ad62f9a3ac45a8843d09f6e24aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feefb3e6313f8bed579aa786814d2099f6364646d6e9c7b53d97bd9260df06bd"
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

      on_macos do
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
