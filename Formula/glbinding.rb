class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.2.tar.gz"
  sha256 "d453d375d3e578fc5990ec41ad648d2ad3de73917a448ff6042bd9f555c0c0c0"

  bottle do
    cellar :any
    sha256 "258219e09335035aebfeea0248c35bbcc1102c0f2b58b827ee2ae28d3bd5fd6d" => :sierra
    sha256 "2725b863dd6375904bdfe1fb26bc014f3a982f8584a5f15b55105b91e6f8cf61" => :el_capitan
    sha256 "8aabae194bf3f9546f2c9a13de096f319caa1643f1b94657beb5d22117518956" => :yosemite
  end

  option "with-glfw", "Enable tools that display OpenGL information for your system"

  depends_on "cmake" => :build
  depends_on "glfw" => :optional
  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DGLFW_LIBRARY_RELEASE=" if build.without? "glfw"
    system "cmake", ".", *args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding",
                    "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
