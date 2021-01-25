class MesaGlu < Formula
  desc "Mesa OpenGL Utility library"
  homepage "https://cgit.freedesktop.org/mesa/glu"
  url "ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.1.tar.xz"
  sha256 "fb5a4c2dd6ba6d1c21ab7c05129b0769544e1d68e1e3b0ffecb18e73c93055bc"
  license any_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "MIT", "SGI-B-2.0"]

  livecheck do
    url :head
    regex(/^(?:glu[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "24874c910bd660366bdc961cf94cfc96a32b372993cffc02e6de5cfb2f14fe05" => :big_sur
    sha256 "00b310b416ecb09febaca37fb246881c561ebea6dbe8676e7c46df7f76527261" => :arm64_big_sur
    sha256 "977fc1911d5d0334c56b9d287de0ee2f716fc23b5fde21404415bf89ce46cfce" => :catalina
    sha256 "ddfad217be6c1f0ea8f22d17348d901ad999365a01f824ab6f51a911eee654e1" => :mojave
    sha256 "598992b552b004eb5e06460a3c84de6ff39f6d7a7112be2819f99280d33f3fa9" => :high_sierra
  end

  head do
    url "https://gitlab.freedesktop.org/mesa/glu.git"

    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mesa"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./autogen.sh", *args if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lGLU", "test.cpp"
  end
end
