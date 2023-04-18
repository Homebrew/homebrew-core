class Glui < Formula
  desc "C++ user interface library"
  homepage "https://glui.sourceforge.io/"
  url "https://github.com/libglui/glui/archive/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"
  license "Zlib"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1ca3761236e58be6553617d9ac8dc0eb3a22e753beab0b3d11d1fbbdba98eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4446bb9bfbe249e1c9b306e5286e0e9279b189def2f1b1c97cb7cbce0a243d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67cba51fd8f00de16bfc0f14db93a31f543681eb558a452a790e0d400a8bbcd4"
    sha256 cellar: :any_skip_relocation, ventura:        "6db07713f38f5fb245d84657f023cdee2a60b0b17fec9f4443c86297e653dfb4"
    sha256 cellar: :any_skip_relocation, monterey:       "1ae9d5b6a49f0a0b82ed3763ba118e7614a690dda330d1db0124293257bc3711"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1884496c319d53faf60c40a4dfe83d0198af2d4a13d377e06c0187624392f74"
    sha256 cellar: :any_skip_relocation, catalina:       "aeea8d3b8f76471bfdcf0f10bb51afc0d721452cbd8fa4613135685d7bbb00ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a89d82496e644e5501928803452b47ff2399c9386757b6013e9a58868255bf90"
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
    if OS.mac?
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
    else
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
