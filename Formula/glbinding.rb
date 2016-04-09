class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.0.1.tar.gz"
  sha256 "6712d91c5f8de81089549e499d8d63554f20abcd250cbfbfae34065760ddf6cb"

  bottle do
    cellar :any
    sha256 "35ad4632733995b8059a99f89ce3262ec277d07a1ae3ff192192cf7385c11913" => :el_capitan
    sha256 "d6a761c8ab022449a2c30bcdf98065b4fe7d109cdb64ac11c2e4f17cb52789af" => :yosemite
    sha256 "c8c63e3dbc77bfb112cd8e1ed3c77f2ae13a05cfc0864673d7ff73c94c722cdd" => :mavericks
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
