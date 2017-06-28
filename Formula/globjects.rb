class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.0.0.tar.gz"
  sha256 "be2f95b4e98eef61a57925985735af266fef667eec63a39f65def5d5d808a30a"
  revision 1
  head "https://github.com/cginternals/globjects.git"

  bottle do
    cellar :any
    sha256 "120730ab24fd8acf2caa89eb48564e1cdee2c5773cacca04fa633b9cfa4a46a1" => :sierra
    sha256 "5896b4d2ea3dea176c8291a39db31762b89256478f9bf14374d55e20b017c4fc" => :el_capitan
    sha256 "813da817fbf45546bbe0cfe9d3beb2e0d4138bf9e5d09a7114e3a825db916d40" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "glbinding"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", "-Dglbinding_DIR=#{Formula["glbinding"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <globjects/globjects.h>
      int main(void)
      {
        globjects::init();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
           "-I#{include}/globjects", "-I#{Formula["glm"].include}/glm", "-I#{lib}/globjects",
           "-lglobjects", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
