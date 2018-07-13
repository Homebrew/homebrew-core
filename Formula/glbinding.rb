class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v3.0.2.tar.gz"
  sha256 "23a383f3ed31af742a4952b6c26faa9c346dd982ba9112c68293a578a6e542ad"

  bottle do
    cellar :any
    sha256 "fd4ecf93841f884924c9394e6c9ce1ceadbd4d4a5d93a8e816ba547873fe8f84" => :high_sierra
    sha256 "17af598a7d19f598412b3c94efe9166ab31f027d81ed3ded7aa7e2e318c2d166" => :sierra
    sha256 "206ed78988d76389de106d58d8b8ffb8417fc1e48ed32141f58e3ebc1f41b77e" => :el_capitan
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
