class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.3.tgz"
  sha256 "2e0a5368917cf0e5467ba8618bc576f50ae9f316c61201635b09711c7908efcc"
  license "GL2PS"
  compatibility_version 1

  livecheck do
    url "https://geuz.org/gl2ps/src/"
    regex(/href=.*?gl2ps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "52ec6b7e9e0fe0284f68f65968e2ee6ff58f280fb0036b35d2f02a987b46b472"
    sha256 cellar: :any, arm64_tahoe:       "724fa9c959ece3a3bb1b88ecfdf998a47697e41a3af09bdc428b06c5d6ce97a7"
    sha256 cellar: :any, arm64_sequoia:     "5a11513099ebc466ea9ea99358ad7fddd200025a671e79524bc242317cd2ef7f"
    sha256 cellar: :any, arm64_linux:       "afba4c8d11516a9e1c77f6526adf47239dcc01aaba74144f85f797e791e13176"
    sha256 cellar: :any, x86_64_linux:      "d3ba7ae699aba5a875a152bddeccff91d2a697ac45e4ad2e09be93f0a27cbf78"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    glu = if OS.mac?
      "GLUT"
    else
      "GL"
    end
    (testpath/"test.c").write <<~C
      #include <#{glu}/glut.h>
      #include <gl2ps.h>

      int main(int argc, char *argv[])
      {
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DEPTH);
        glutInitWindowSize(400, 400);
        glutInitWindowPosition(100, 100);
        glutCreateWindow(argv[0]);
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        FILE *fp = fopen("test.eps", "wb");
        GLint buffsize = 0, state = GL2PS_OVERFLOW;
        while( state == GL2PS_OVERFLOW ){
          buffsize += 1024*1024;
          gl2psBeginPage ( "Test", "Homebrew", viewport,
                           GL2PS_EPS, GL2PS_BSP_SORT, GL2PS_SILENT |
                           GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                           GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT,
                           GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                           fp, "test.eps" );
          gl2psText("Homebrew Test", "Courier", 12);
          state = gl2psEndPage();
        }
        fclose(fp);
        return 0;
      }
    C
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework", "GLUT",
                     "-framework", "Cocoa", "test.c", "-o", "test"

      # GLUT needs a WindowServer connection, which the test sandbox denies
      return
    else
      system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lgl2ps", "-lglut", "-lGL"
    end
    if OS.linux? && ENV.exclude?("DISPLAY")
      system formula_opt_bin("xorg-server")/"xvfb-run", "./test"
    else
      system "./test"
    end
    assert_path_exists testpath/"test.eps"
    assert_predicate File.size("test.eps"), :positive?
  end
end
