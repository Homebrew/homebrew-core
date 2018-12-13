class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.1.0.tar.gz"
  sha256 "68fa218c1478c09b555e44f2209a066b28be025312e0bab6e3a0b142a01ebbc6"
  head "https://github.com/cginternals/globjects.git"

  bottle do
    cellar :any
    sha256 "9bbf36b86602a7b0c7bf66bb911e200e4f7b94f05c304afb261781edebf119ce" => :mojave
    sha256 "baae740c033bc384454f81c0abba246f935765ec7decf408777d318d60cbe565" => :high_sierra
    sha256 "dacabb07360fa768e54e9436f071a6ac2a56d0fc9da0d72b491fb8a645f48c33" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glbinding"
  depends_on "glm"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", "-Dglbinding_DIR=#{Formula["glbinding"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <globjects/globjects.h>
      int main(void)
      {
        globjects::init();
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
           "-I#{include}/globjects", "-I#{Formula["glm"].include}/glm", "-I#{lib}/globjects",
           "-L#{lib}", "-L#{Formula["glbinding"].opt_lib}",
           "-lglobjects", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
