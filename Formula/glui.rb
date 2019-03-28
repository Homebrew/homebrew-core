class Glui < Formula
  desc "C++ user interface library"
  homepage "https://glui.sourceforge.io/"
  url "https://github.com/libglui/glui/archive/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e22ebbb1c0e2065dc69936bea4c7afd080ad7849a84816142284c071348a1f20" => :mojave
    sha256 "c6968d950e93bb81b88c656ecaddd5400a924386fcdeecb6d185cf4ec4d8d7cf" => :high_sierra
    sha256 "36971571cceb35b758732131c7c9495d01b95fb2d4130000039c1b9d9a3922d8" => :sierra
    sha256 "eae0f5aab2883fa397f09bb314a90672e41c39c24e0c43e49259c8016b1c50db" => :el_capitan
    sha256 "617c71a79c2ce69ff31e7bd84e9e4f41b09e8cf3d039190bef92ad6bf1ae416c" => :yosemite
    sha256 "1a5b5bc92fbb7077f11f53fcbd16d1e63b1e04850d029afa2a8e82822a5e82e4" => :mavericks
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
