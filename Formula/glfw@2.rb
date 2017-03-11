class GlfwAT2 < Formula
  homepage "http://www.glfw.org/"
  url "https://downloads.sourceforge.net/project/glfw/glfw/2.7.9/glfw-2.7.9.tar.bz2"
  sha256 "d1f47e99e4962319f27f30d96571abcb04c1022c000de4d01df69ec59aae829d"

  keg_only :versioned_formula

  def install
    system "make", "PREFIX=#{prefix}", "cocoa-dist-install"
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
