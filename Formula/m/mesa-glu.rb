class MesaGlu < Formula
  desc "Mesa OpenGL Utility library"
  homepage "https://gitlab.freedesktop.org/mesa/glu"
  url "https://archive.mesa3d.org/glu/glu-9.0.3.tar.xz"
  sha256 "bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f"
  license any_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "MIT", "SGI-B-2.0"]
  head "https://gitlab.freedesktop.org/mesa/glu.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "04be327648775a1c07ed70dd1fbe931983e013381f3459c10c12132fee8c7283"
    sha256 cellar: :any,                 arm64_sequoia:  "20ebc8dee6088f6f72e85c115535d7ae2d91af99b06dfa347bb9fb159d1e593c"
    sha256 cellar: :any,                 arm64_sonoma:   "a46115bd23886619f38846580237988bfa061f33c7c1e0ff29e9663a581a7c86"
    sha256 cellar: :any,                 arm64_ventura:  "1006d795c57a2c0dd47b6bd67bd77f28b4c72e8428574e7d97f886928eedd41c"
    sha256 cellar: :any,                 arm64_monterey: "bba71b29396ad2355cfa1e4fa058f88971f590b32ab46d4b2aa79a4071766873"
    sha256 cellar: :any,                 sonoma:         "f358d5011c1944797eaa8a8c892c5437484d2a74a02389edcb3772cfaff7a565"
    sha256 cellar: :any,                 ventura:        "b4736c1784135e82aeb5295997651aeac7305709b345166ba3fd24a901339fcd"
    sha256 cellar: :any,                 monterey:       "807e0114c95152e4a4b4a4b72f0270415aa83eb0211a43488d88c65da65e85fe"
    sha256                               arm64_linux:    "24b267be5f6ae9004eb11f15a427187078c08a201a777c5a72bb545966786566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e93794ed9518e89338dcfad821b7dbd184c3d46a843b52c05548ffe5bd5f00"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "mesa"

  def install
    system "meson", "setup", "build", "-Dgl_provider=gl", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <GL/glu.h>

      int main(int argc, char* argv[]) {
        static GLUtriangulatorObj *tobj;
        GLdouble vertex[3], dx, dy, len;
        int i = 0;
        int count = 5;
        tobj = gluNewTess();
        gluBeginPolygon(tobj);
        for (i = 0; i < count; i++) {
          vertex[0] = 1;
          vertex[1] = 2;
          vertex[2] = 0;
          gluTessVertex(tobj, vertex, 0);
        }
        gluEndPolygon(tobj);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lGLU"
  end
end
