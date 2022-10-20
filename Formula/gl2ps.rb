class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.2.tgz"
  sha256 "8d1c00c1018f96b4b97655482e57dcb0ce42ae2f1d349cd6d4191e7848d9ffe9"
  license "GL2PS"

  livecheck do
    url "https://geuz.org/gl2ps/src/"
    regex(/href=.*?gl2ps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e08ec8cea6a733012aadbd5b2eeef661030005c1a7b24f77f5371385191ed921"
    sha256 cellar: :any,                 arm64_big_sur:  "02cad33d0c39773c7a0c0983f125fc04fe86d265b31cac034be45379265e65be"
    sha256 cellar: :any,                 monterey:       "be22c8b58f988c2ad5ca8527f374febb62193cec05c910c14d639101d9e32cc3"
    sha256 cellar: :any,                 big_sur:        "4ad3d5fcf0a8393e77881e4ea73c160200f6573aa05f6db84e452d920a5f7185"
    sha256 cellar: :any,                 catalina:       "dbdfe5d8458e1224941d6e5707b725ab6872333112dc408dbf35202eddbc8d15"
    sha256 cellar: :any,                 mojave:         "bc857ec44c73448acf748dea7a699e1018a874196dec19659a63aa70a7b5e970"
    sha256 cellar: :any,                 high_sierra:    "6c36dc780b0579f44057cadddb9e1a2e369e2ba9205b68d6c81ebd79defc45b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85c3e2f25855ef919358e1912f3190ba8e6890cfd5329931638b595cab962d1"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "freeglut"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    glu = if OS.mac?
      "GLUT"
    else
      "GL"
    end
    (testpath/"test.c").write <<~EOS
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
    EOS
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework", "GLUT",
                     "-framework", "Cocoa", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lgl2ps", "-lglut", "-lGL"

      # Fails without an X11 display: freeglut (./test): failed to open display ''
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system "./test"
    assert_predicate testpath/"test.eps", :exist?
    assert_predicate File.size("test.eps"), :positive?
  end
end
