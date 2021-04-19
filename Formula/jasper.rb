class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://jasper-software.github.io/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.32.tar.gz"
  sha256 "a3583a06698a6d6106f2fc413aa42d65d86bedf9a988d60e5cfa38bf72bc64b9"
  license "JasPer-2.0"

  bottle do
    sha256 arm64_big_sur: "71e7ff8e942a88baa807484a5f0d0160b66ddc5f37d2164072d400aa5a067865"
    sha256 big_sur:       "adec70da00a25292537178182308b7d78ff730b4e0b8f80e4c000f147a53057e"
    sha256 catalina:      "22f7db62bfc894c3836dc6c170399f767363efb589b9057a754238be5563f7aa"
    sha256 mojave:        "2376a32bbfdcddc6f1893ae0e9a5832860fcc1c647397e32830576d8ef1a4d1e"
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
