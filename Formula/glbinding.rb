class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v3.1.0.tar.gz"
  sha256 "6729b260787108462ec6d8954f32a3f11f959ada7eebf1a2a33173b68762849e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "5c77227ab2d41d56069711ea964f5222feb1d9f1f88228b88ff657131cec9093"
    sha256 cellar: :any, big_sur:       "a77f29c6cc40472d39646027e3d9b068ff5cf912edf600087ef4902e30f501a0"
    sha256 cellar: :any, catalina:      "6a371e47b76cd227e12699de3e7a095e620150532789cdac48e1c9b59bee06b6"
    sha256 cellar: :any, mojave:        "a44cd2f23650ce664d8f61634c27abce3a00f4b5d9efbb10687759a62ca26895"
    sha256 cellar: :any, high_sierra:   "ad79687ca8b43832ab27d5a459a71c4cb7e2be5b02d5df15c667ad7689fe38d0"
    sha256 cellar: :any, sierra:        "454bfd4f3f6a983a0614f469388cbe27437350d203c61aed34a8c05fa9bb0710"
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
      #include <glbinding/glbinding.h>
      #include <glbinding/getProcAddress.h>

      int main(void)
      {
        glbinding::initialize(glbinding::getProcAddress);
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", "-framework", "OpenGL",
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
