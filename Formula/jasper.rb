class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.25.tar.gz"
  sha256 "f5bc48e2884bcabd2aca1737baff4ca962ec665b6eb673966ced1f7adea07edb"
  license "JasPer-2.0"

  bottle do
    sha256 arm64_big_sur: "5ba3a6e30875d6e28940223516c8d86f2524a185c9869353b92e4219bfd50ce6"
    sha256 big_sur:       "680a5b7d142725d300d4148bf1945e2d0c8dfe3a385e39e6e86daecd31890456"
    sha256 catalina:      "7f43ea0135a2397f28eee1a3cc11714106dc924fd6a5c3331f4e79570d40772b"
    sha256 mojave:        "458ef25c230bd9e5fd31519926625f5cb391f8af016f11b0853d9801540b60b4"
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
