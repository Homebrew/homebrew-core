class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.2.tar.gz"
  sha256 "e6eb28c6c5dfe5730d26e1908f9be68f48f39461acd3c686544837de14103a4c"

  bottle do
    sha256 "362a325e069e0929def99a97ffad3d7dad2ede225e5c21120c451904df14c12d" => :sierra
    sha256 "0affc75abd83953699c90f1b405333350ce5673952976f5f5e9962f221c4c038" => :el_capitan
    sha256 "50c0c3214b87bdf3fd875f3f4b70dfe9a9fc1fe3a1e5ed113a595f995b862c50" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    ENV.universal_binary if build.universal?

    # Fix OpenGL support
    # Upstream issue "Build fails to find and link system GLUT on macOS"
    # Reported 1 Dec 2016 https://github.com/mdadams/jasper/issues/100
    ["CMakeLists.txt", "src/appl/jiv.c"].each do |f|
      inreplace f, "GL/glut.h", "glut.h"
    end
    inreplace "src/appl/CMakeLists.txt",
      "add_executable(jiv jiv.c)",
      "add_executable(jiv jiv.c)\n\tinclude_directories(${GLUT_INCLUDE_DIR})"

    mkdir "build" do
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
