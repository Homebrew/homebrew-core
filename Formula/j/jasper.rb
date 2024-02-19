class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.0/jasper-4.2.0.tar.gz"
  sha256 "69f0b08a0cc281a06eaf7feed510736854bbff9af89ab1d01b77382ad57ec957"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c9bcca6982067cc2fbe581808814806431f95d34e46fd2ac3588e46ddd282de"
    sha256 cellar: :any,                 arm64_ventura:  "f165aaf6965f7896ccbb35f62b58333508965fc2dc7944e19c48ad7631f881a0"
    sha256 cellar: :any,                 arm64_monterey: "50358acb061f2f0e270f8f947da1566a0390e39218a5db5efc5aa42a9b4f53cf"
    sha256 cellar: :any,                 sonoma:         "3e576ec9d9307244f67d6d242983b643f84368dbe45d9f2672ebeacdebd3476f"
    sha256 cellar: :any,                 ventura:        "a781e2eb475b8e57daac5cc1d55e518286ff8b3974b00862f2f1bc205ab47e8d"
    sha256 cellar: :any,                 monterey:       "5ad2357330c0961287913d12c08bc2f4f7880915820c6afbacc6dd2da9ec3d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa11fd7427376996ed0ba4878977d1beb863314d1744a0ab79eda9eec677a87"
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
