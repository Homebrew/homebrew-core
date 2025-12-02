class Glui < Formula
  desc "C++ user interface library"
  homepage "https://github.com/libglui/glui"
  url "https://github.com/libglui/glui/archive/refs/tags/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"
  license "Zlib"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "291a1781d586b21b5ff3260f10e82cf9604a364ff5396b5eba33a28e6fce90cb"
    sha256 cellar: :any,                 arm64_sequoia: "8571bc2053756921d417d2ffbd49259fcc18f9068f3647cbfeaf4c310cf1f23d"
    sha256 cellar: :any,                 arm64_sonoma:  "b3127c49849ab12bb7ef689a8bf6191012175b219249166fef57f9dc540ef3e3"
    sha256 cellar: :any,                 arm64_ventura: "61a624ac60981cb7dbbbf7c4049bb3d0b19285c732d9178219932641c9fa0799"
    sha256 cellar: :any,                 sonoma:        "723eecbda46e12ba8d1c0c65c4d582bc86b8240e893656695d1392ac4dc10e40"
    sha256 cellar: :any,                 ventura:       "dd8fd33cb3acc7d02eb0506368fde6bab453eed79ea0d5e8de13ad23dd0874c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c229cda6f60b66c2f598d50dbf71a9dda1099d731c16f5d70ac7704c0c19f112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b399324e278b5f0ec7d1dece5994eb01384929dfbb85893743b97c929467a743"
  end

  depends_on "cmake" => :build

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

  # Backport fix for CMake build linking on macOS
  patch do
    url "https://github.com/libglui/glui/commit/eaca63aea72ed4db055514dfec2abc71a106aa70.patch?full_index=1"
    sha256 "81cd6400037f9082ffd2926a01458c40c0d81c71cb7786cb667909ef64b1541b"
  end

  # Backport support for CMake install
  patch do
    url "https://github.com/libglui/glui/commit/4299e8fa43bb1e67370be36cad4b21115ab88af9.patch?full_index=1"
    sha256 "9070d9a3f44ffd3787762125fb194d92e24a9bc0b5e27bc5571ac09718199404"
  end

  def install
    # Find framework first to avoid linking to XQuartz libraries if installed
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      (testpath/"test.cpp").write <<~CPP
        #include <cassert>
        #include <GL/glui.h>
        int main() {
          glutDisplayFunc([](){});
          GLUI *glui = GLUI_Master.create_glui("GLUI");
          assert(glui != nullptr);
          return 0;
        }
      CPP
      system ENV.cxx, "-framework", "GLUT", "-framework", "OpenGL", "-I#{include}",
        "-L#{lib}", "-lglui", "-std=c++11", "test.cpp"

      # Tahoe running is headless for now, maybe remove this later
      # ("GLUT Fatal Error: redisplay needed for window 1, but no display callback")
      return if MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

      system "./a.out"
    else
      (testpath/"test.cpp").write <<~CPP
        #include <cassert>
        #include <GL/glui.h>
        #include <GL/glut.h>
        int main(int argc, char **argv) {
          glutInit(&argc, argv);
          glutDisplayFunc([](){});
          GLUI *glui = GLUI_Master.create_glui("GLUI");
          assert(glui != nullptr);
          return 0;
        }
      CPP
      system ENV.cxx, "-I#{include}", "-std=c++11", "test.cpp",
        "-L#{lib}", "-lglui", "-lglut", "-lGLU", "-lGL"
      if ENV["DISPLAY"]
        # Fails without X display: freeglut (./a.out): failed to open display ''
        system "./a.out"
      end
    end
  end
end
