class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.2.1.tar.gz"
  sha256 "e10f0de1384d75e6fc210c53e91843f6110d6c4f3afbfb588130713c2f9d8fe8"
  head "https://github.com/glfw/glfw.git"

  bottle do
    cellar :any
    sha256 "04b6332acfa686339994bd5b8409a11601bdf03c70ba611792e3575eec638ac9" => :mojave
    sha256 "dd4e0a7ec81510315f7f3a443c09f682ff95b6edd59f1f1e507d656aabe86b41" => :high_sierra
    sha256 "c19bbe78ab9d7d376b2cd265389348e4ad4572b9881bb1048b05d3eb4bc67762" => :sierra
    sha256 "874e364604c386252a1d639f24c8d2333bc4715c67acd77109c291d724509538" => :el_capitan
    sha256 "ecfc037c61cedd936d230880dd052691e8c07c4f10c3c95ccde4d8bc4e3f5e35" => :yosemite
  end

  option "without-shared-library", "Build static library only (defaults to building dylib only)"

  deprecated_option "static" => "without-shared-library"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]
    args << "-DBUILD_SHARED_LIBS=TRUE" if build.with? "shared-library"

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    if build.with? "shared-library"
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw"
    else
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw3",
             "-framework", "IOKit",
             "-framework", "CoreVideo",
             "-framework", "AppKit"
    end
    system "./test"
  end
end
