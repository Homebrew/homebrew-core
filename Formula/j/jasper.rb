class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.4/jasper-4.2.4.tar.gz"
  sha256 "6a597613d8d84c500b5b83bf0eec06cd3707c23d19957f70354ac2394c9914e7"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ae5a19fe27ce17c27965adda1ef26fdfcf37930ca43fe9f05a60967273eaa3ea"
    sha256 cellar: :any,                 arm64_sonoma:  "ee37209f33bc9a553d7d4cc6340d6cce02265699b6cfd3120b969897f7f3c66b"
    sha256 cellar: :any,                 arm64_ventura: "26a590dd28ce14c8c8d21daae5c40f2315596dff9da3a8f062b3c7f68c6f4884"
    sha256 cellar: :any,                 sonoma:        "f7fa9f0518f18c0e2856b21b53a9608942fe76a406ba1d22645d73b76a873fc0"
    sha256 cellar: :any,                 ventura:       "cd0eff6cd64657baaeab5db4cb40d91976c1774a11a65602c511f8e83c223bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cef68cee21420fe8cba6a74bf82a0fddc67b6ff1f96b5d0e6901fa0039ab2ef"
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

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/jasper.pc", prefix, opt_prefix
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_path_exists testpath/"test.bmp"
  end
end
