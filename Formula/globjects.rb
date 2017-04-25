class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.0.0.tar.gz"
  sha256 "be2f95b4e98eef61a57925985735af266fef667eec63a39f65def5d5d808a30a"
  revision 1
  head "https://github.com/cginternals/globjects.git"

  bottle do
    cellar :any
    sha256 "fd8e1291e9e46a57116ce1533a8ef9243f1949f18b866f655cd0c245e8d7849d" => :sierra
    sha256 "4e2d49ddfc4c868561ea4a4970eb9447c8b0c951dd58e5057ced8ce5c2c90e4b" => :el_capitan
    sha256 "06d967f26d47c9c6532ee24485e5cde3eeb5d74feccdfde46811048c97a18b5a" => :yosemite
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
