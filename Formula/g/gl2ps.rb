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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cfd40bfcb06fceef93e5b04ff17a59a5df05742997959ecd4be2c9f3badc2c70"
    sha256 cellar: :any,                 arm64_sequoia: "d45044992b502ffb0a34647b504eff67e034635c0d6c06fb580b504b3cdf9c80"
    sha256 cellar: :any,                 arm64_sonoma:  "86df24cf3d5f86fd5d4d0a279126e8f0bfad2560637017b30ce3b8cee638fa4e"
    sha256 cellar: :any,                 sonoma:        "17b1449046f6a3a523608a8b71277a442927ead68405f4a4881ac2686da8cea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "852d33552ed074a82702007c52ac923cac04188db2c237fcffd2b4cacfc50342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892849e15a461c6ca9b2c24178518a6769d78807ef6c0c99a0b6997321c9be4b"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

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

      # Tahoe running is headless for now, maybe remove this later
      # ("GLUT Fatal Error: redisplay needed for window 1, but no display callback")
      return if MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]
    else
      system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lgl2ps", "-lglut", "-lGL"
    end
    if OS.linux? && ENV.exclude?("DISPLAY")
      system Formula["xorg-server"].bin/"xvfb-run", "./test"
    else
      system "./test"
    end
    assert_path_exists testpath/"test.eps"
    assert_predicate File.size("test.eps"), :positive?
  end
end
