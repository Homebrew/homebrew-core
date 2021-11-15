class Glui < Formula
  desc "C++ user interface library"
  homepage "https://glui.sourceforge.io/"
  url "https://github.com/libglui/glui/archive/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ff557155b204660a6b14fc2da0f53a4e3cb9162ab53cde30fabdca09ee622d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2436b9df6b4d25bcd4734c5257ad4388fe4b9591396f155e6dd7d716093d8836"
    sha256 cellar: :any_skip_relocation, monterey:       "105ab3a95a4d7cf9c90abc55d3905a0ac0a06417f9c91b7dd320a02d06b59751"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0e6490b5f5044282ef8769a9702597667dfc5bfc72331790deeac6997116d6d"
    sha256 cellar: :any_skip_relocation, catalina:       "a9e404e892ccdf44f28504a433b598a08533290486189bc4a707b3e333dd3950"
    sha256 cellar: :any_skip_relocation, mojave:         "24c323dbaa5f6f1b01fbf8f837c379ef503d323a448d2bb3d673c31ced622f0d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7cd9b9d6bffa3b6b6ff806c4041f495d5a7ef40296cb50097db25d17eb616265"
    sha256 cellar: :any_skip_relocation, sierra:         "c087de27b46b86a14d583904e0a9d293428af37d8710b521ae7aeeb5174fc8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4ce0caa6084beb02f121cf35dc27ea8cc5097fbc6368803e725e9c7aa5c48a"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
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
    on_macos do
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

    on_linux do
      (testpath/"test.cpp").write <<~EOS
        #include <cassert>
        #include <GL/glui.h>
        #include <GL/glut.h>
        int main(int argc, char **argv) {
          glutInit(&argc, argv);
          GLUI *glui = GLUI_Master.create_glui("GLUI");
          assert(glui != nullptr);
          return 0;
        }
      EOS
      system ENV.cxx, "-I#{include}", "-std=c++11", "test.cpp",
        "-L#{lib}", "-lglui", "-lglut", "-lGLU", "-lGL"
      if ENV["DISPLAY"]
        # Fails without X display: freeglut (./a.out): failed to open display ''
        system "./a.out"
      end
    end
  end
end
