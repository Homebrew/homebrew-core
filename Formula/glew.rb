class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
  sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "a0d99f5538ffc0a182f227934753b0129b5b6cdfdc790cf7ef208fb4d8b00845" => :el_capitan
    sha256 "351ff9dbee1b1307720a2e3ad8e86c28975b3bc2614cfbc7ae45492cb3810062" => :yosemite
    sha256 "a8d8c2095176c09b10667627de9861b0e35d310bcd860922a2be4037a3e6418c" => :mavericks
  end

  option :universal

  def install
    if build.universal?
      ENV.universal_binary

      # Do not strip resulting binaries; https://sourceforge.net/p/glew/bugs/259/
      ENV["STRIP"] = ""
    end

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <GL/glew.h>
      #include <GLUT/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-o", "test", "-L#{lib}", "-lGLEW",
           "-framework", "GLUT"
    system "./test"
  end
end
