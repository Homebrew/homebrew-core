class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.2.2/jasper-4.2.2.tar.gz"
  sha256 "5e397570b3110a8edef6d50127e20a2297939809cea25d29068823b442ecdd6d"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "153fa2951b935f726b0f2bdd181d680f5b46d8d5d8eda7e1383c74d608ed3911"
    sha256 cellar: :any,                 arm64_ventura:  "13e92fd59dd2344cbfeaeb3ae349c7f8a0054d371a6f5a64d3dc6f0ac081e89d"
    sha256 cellar: :any,                 arm64_monterey: "0919d6151a5491b95901143a6fa022d5b07de28164615a483d585eb130ff6e83"
    sha256 cellar: :any,                 sonoma:         "997d1c057acf7ec2885f7ff791e7ea784126c7c45c3304c1017ee92aa1d4f919"
    sha256 cellar: :any,                 ventura:        "680151d52999273d2e6f21876bf8a2532289d287004434a3b014d04c8f12b93f"
    sha256 cellar: :any,                 monterey:       "b26e6e699e8c678852a4371756a9130f7c4be79db2aafcbefbe8630b8265a85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96bc7f5d95349b6e9e4d8400c114043d0d8e50888e33ca46eef7697b0a453e64"
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
