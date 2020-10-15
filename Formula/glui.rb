class Glui < Formula
  desc "C++ user interface library"
  homepage "https://glui.sourceforge.io/"
  url "https://github.com/libglui/glui/archive/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9e404e892ccdf44f28504a433b598a08533290486189bc4a707b3e333dd3950" => :catalina
    sha256 "24c323dbaa5f6f1b01fbf8f837c379ef503d323a448d2bb3d673c31ced622f0d" => :mojave
    sha256 "7cd9b9d6bffa3b6b6ff806c4041f495d5a7ef40296cb50097db25d17eb616265" => :high_sierra
    sha256 "c087de27b46b86a14d583904e0a9d293428af37d8710b521ae7aeeb5174fc8fd" => :sierra
  end

  # Fix compiler warnings in glui.h. Merged into master on November 28, 2016.
  patch do
    url "https://github.com/libglui/glui/commit/fc9ad76733034605872a0d1323bb19cbc23d87bf.patch?full_index=1"
    sha256 "b1afada854f920692ab7cb6b6292034f3488936c4332e3e996798ee494a3fdd7"
  end

  def install
    system "make", "setup"
    system "make", "lib/libglui.a"
    lib.install "lib/libglui.a"
    include.install "include/GL"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <GL/glui.h>
      int main() {
        GLUI *glui = GLUI_Master.create_glui("GLUI");
        assert(glui != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "-framework", "GLUT", "-framework", "OpenGL", "-I#{include}",
      "-L#{lib}", "-lglui", "-std=c++11", "test.cpp"
    system "./a.out"
  end
end
