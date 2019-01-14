class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.4.tar.gz"
  sha256 "cb5971b086c0d217b2304d31368803fd2b8c12ee0d41c280d40d7c23588f8be2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a44cd2f23650ce664d8f61634c27abce3a00f4b5d9efbb10687759a62ca26895" => :mojave
    sha256 "ad79687ca8b43832ab27d5a459a71c4cb7e2be5b02d5df15c667ad7689fe38d0" => :high_sierra
    sha256 "454bfd4f3f6a983a0614f469388cbe27437350d203c61aed34a8c05fa9bb0710" => :sierra
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args, "-DGLFW_LIBRARY_RELEASE="
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
