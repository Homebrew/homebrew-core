class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.4.tar.gz"
  sha256 "cb5971b086c0d217b2304d31368803fd2b8c12ee0d41c280d40d7c23588f8be2"

  bottle do
    cellar :any
    sha256 "449a9143da94089be7edce1050470831410bd2c4cdf341f6666af9e52f6d4947" => :high_sierra
    sha256 "792fd850648cdeea9e5e8a699ba1554e3936b62419c3a0912c81ce22b58d096e" => :sierra
    sha256 "c26c8b3e87d1721dc224a5b8c3438c451fc2661fb184f3d450cff051f61a64cd" => :el_capitan
    sha256 "f8143d1a2fcf8a3d08d85b964d6325068c19c19565c463559dc9f264b65766ed" => :yosemite
  end

  option "with-glfw", "Enable tools that display OpenGL information for your system"
  option "with-static", "Build static instead of shared glbinding libraries"

  depends_on "cmake" => :build
  depends_on "glfw" => :optional
  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DGLFW_LIBRARY_RELEASE=" if build.without? "glfw"
    args << "-DBUILD_SHARED_LIBS:BOOL=OFF" if build.with? "static"
    system "cmake", ".", *args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", "-framework", "OpenGL",
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
