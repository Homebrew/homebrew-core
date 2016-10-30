class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.1.tar.gz"
  sha256 "253671f2b730a6efa55de92a704938bb0f1761d151f3f8e87c043c51d46ea1e4"

  bottle do
    cellar :any
    sha256 "68452e05178ce9dd90cc47aa62e5c2508ff8ffbbc3ed5054e20b65130f370231" => :sierra
    sha256 "a41937f898840ca580188b002308a6e13696e1e659feda33493f0c6c4cf9287f" => :el_capitan
    sha256 "773e5ce2e1012af403b58e0db3f4cc0f7b98d111eaea9cab528057d27c5c7c35" => :yosemite
    sha256 "97b4e0dc61be2fdd33928db4b2ed51250f38b4cab55310819715ef6f9f324530" => :mavericks
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
