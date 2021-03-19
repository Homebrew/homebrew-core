class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.27.tar.gz"
  sha256 "df41bd015a9dd0cc2a2e696f8ca5cbfb633323ca9429621f7fa801778681f2dd"
  license "JasPer-2.0"

  bottle do
    sha256 arm64_big_sur: "dedf51908cf539c24cd195e105c7f6d54cbcd0b120015e906f7ab5c6b7c62ffb"
    sha256 big_sur:       "b4f893059b48d3bcecafbfcc58d867d9770772e398401f84b846fbae21fa1741"
    sha256 catalina:      "7ff4907367a4d6d0fa8f1370ab2a866688f9aba18670ba9420cdfcecc797a113"
    sha256 mojave:        "bde3ae3b0d6656c3b57ef597e2e0d826a163549fab594faec5c008725e8959fc"
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
