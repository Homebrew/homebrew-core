class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.2.tar.gz"
  sha256 "e6eb28c6c5dfe5730d26e1908f9be68f48f39461acd3c686544837de14103a4c"

  bottle do
    sha256 "5e42b5b4ae2ff764079d2ee805058dd333ad7725685de8b712a702804f6dd83c" => :sierra
    sha256 "736a94e34a6a9cad6d670db0ab46d99abb2a89a0fcf94deede2dacf369cca143" => :el_capitan
    sha256 "37ba845ad48b604d201b6f00aa2cdff4ea82d0dde7c1697e85f719e1fe52e637" => :yosemite
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
