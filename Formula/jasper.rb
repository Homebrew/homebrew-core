class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://jasper-software.github.io/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.31.tar.gz"
  sha256 "d419baa2f8a6ffda18472487f6314f0f08b673204723bf11c3a1f5b3f1b8e768"
  license "JasPer-2.0"

  bottle do
    sha256 arm64_big_sur: "5604e79b10e27efa6e4e35e1456144cad112026a22ecf1c79a97aecec329f8a1"
    sha256 big_sur:       "c2f017e9709d58c1c556166e34c3ace39112bd3961786ef283692aafb488280a"
    sha256 catalina:      "a0b4f663dd672852de17cf2db9c017418d499b403b7a6fb5d2a9165253deee54"
    sha256 mojave:        "296e6360c85a2caa666bf04d530648535f9cf9d50f7015ed118ca64bcf824aae"
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
