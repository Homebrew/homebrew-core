class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.3.tar.gz"
  sha256 "48f2e590a4a951005f79fec6c487217aa9b344a33ca1a8d2b7e618f04681ec60"

  bottle do
    cellar :any
    sha256 "792fd850648cdeea9e5e8a699ba1554e3936b62419c3a0912c81ce22b58d096e" => :sierra
    sha256 "c26c8b3e87d1721dc224a5b8c3438c451fc2661fb184f3d450cff051f61a64cd" => :el_capitan
    sha256 "f8143d1a2fcf8a3d08d85b964d6325068c19c19565c463559dc9f264b65766ed" => :yosemite
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
