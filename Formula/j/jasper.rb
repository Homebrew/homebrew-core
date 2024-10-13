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
    sha256 cellar: :any,                 arm64_sequoia:  "6d7a00cd2f4286a4d90f1674cdc5a152632211cabf335c65106d6e24a2ca2b89"
    sha256 cellar: :any,                 arm64_sonoma:   "a9c32c908bdf797743a22d851efd4c28b6abf6ad132bcececfb83de354383f72"
    sha256 cellar: :any,                 arm64_ventura:  "c3215fa4215361e882b4701ac82da30bf175d3f13e9e34ebc375c1406f6ab1b4"
    sha256 cellar: :any,                 arm64_monterey: "180626f41ecce9cec96f869ac6efc0106cd7442eb887a00809f3fedf82db4a89"
    sha256 cellar: :any,                 sonoma:         "ccc68dcf709d995ef9f91ab109a2dcabbc9aba82c475a9d32309545df18f155e"
    sha256 cellar: :any,                 ventura:        "18d3d583cb960f8e4872ffc5b2181b6282f95d2c1ebd3a659d0e0b3edf55bc10"
    sha256 cellar: :any,                 monterey:       "09c601a2f468798fe0746f56a47a9ba3d3642c9da9b08a3cc57a4b99ab7105bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a209bbc3755e5ae06cf4c7ab8040e079b0202635555ea4c75e8e36d8137c74"
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
