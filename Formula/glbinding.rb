class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.0.1.tar.gz"
  sha256 "6712d91c5f8de81089549e499d8d63554f20abcd250cbfbfae34065760ddf6cb"

  bottle do
    sha256 "267be079b0657c4cc1cb4002bf4047d358630404e2ea0bcb966a5730b6a0641e" => :el_capitan
    sha256 "39355e37b3417a03a2b8ee7ce46fa27cdf72706a4ee4227fbe8cdfd9fa3a8e05" => :yosemite
    sha256 "d4e319797d5b4dbf44dcd99f01de934941d7e39e82bcf66508853b386b2bdeab" => :mavericks
  end

  option "with-glfw3", "Enable tools that display OpenGL information for your system"

  depends_on "cmake" => :build
  depends_on "homebrew/versions/glfw3" => :optional
  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
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
