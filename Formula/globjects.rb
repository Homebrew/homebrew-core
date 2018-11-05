class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.1.0.tar.gz"
  sha256 "68fa218c1478c09b555e44f2209a066b28be025312e0bab6e3a0b142a01ebbc6"
  head "https://github.com/cginternals/globjects.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b46876c9f36cfb5474e7ad8f9c0bb5d2475ee79f0d59bad29dd243562dd80113" => :mojave
    sha256 "9e7b31871b690eac2baa0b5bded3b24c07c1f0ca7439e8096495b7b90d334b90" => :high_sierra
    sha256 "d14f12ff4179fb813b75d797f2ef49a18a308881465ac32503a52ec2acf3b333" => :sierra
    sha256 "90fdeaee9a05ffecebce8f8a4584f75c36cc97750666ed0c2eff2aee85c7a82f" => :el_capitan
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
