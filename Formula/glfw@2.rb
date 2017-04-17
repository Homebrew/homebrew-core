class GlfwAT2 < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "http://www.glfw.org/"
  url "https://downloads.sourceforge.net/project/glfw/glfw/2.7.9/glfw-2.7.9.tar.bz2"
  sha256 "d1f47e99e4962319f27f30d96571abcb04c1022c000de4d01df69ec59aae829d"

  bottle do
    cellar :any
    sha256 "2ff2da070cde54e70c7bfce95ab2bba75b5c096bcf6e77f7148921b3e7ea0341" => :sierra
    sha256 "f31d46ba9f93f445f1d780d0523ef2c3499bda05dae1cd06c58da90c829ac8cd" => :el_capitan
    sha256 "e4bc5f41b85d95c41b0582fdcfa538f4183b86cbdfe4399237b8f2580c01eb32" => :yosemite
  end

  keg_only :versioned_formula

  def install
    system "make", "PREFIX=#{prefix}", "cocoa-dist-install"
    MachO::Tools.change_dylib_id("#{lib}/libglfw.dylib",
                                 "@opt_lib/libglfw.dylib")
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #define GLFW_INCLUDE_GLU
      #include <GL/glfw.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lglfw"
    system "./test"
  end
end
