class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v3.1.0.tar.gz"
  sha256 "6729b260787108462ec6d8954f32a3f11f959ada7eebf1a2a33173b68762849e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6a371e47b76cd227e12699de3e7a095e620150532789cdac48e1c9b59bee06b6" => :catalina
    sha256 "a44cd2f23650ce664d8f61634c27abce3a00f4b5d9efbb10687759a62ca26895" => :mojave
    sha256 "ad79687ca8b43832ab27d5a459a71c4cb7e2be5b02d5df15c667ad7689fe38d0" => :high_sierra
    sha256 "454bfd4f3f6a983a0614f469388cbe27437350d203c61aed34a8c05fa9bb0710" => :sierra
  end

  depends_on "cmake" => :build

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
        glbinding::Binding::initialize(nullptr);
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", "-framework", "OpenGL",
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
