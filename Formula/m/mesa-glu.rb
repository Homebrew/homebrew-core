class MesaGlu < Formula
  desc "Mesa OpenGL Utility library"
  homepage "https://cgit.freedesktop.org/mesa/glu"
  url "ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.2.tar.xz"
  sha256 "6e7280ff585c6a1d9dfcdf2fca489251634b3377bfc33c29e4002466a38d02d4"
  license any_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "MIT", "SGI-B-2.0"]

  livecheck do
    url :head
    regex(/^(?:glu[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a1ee4a15d74adb93d0328abc6a03290714dd612186df3d4f5213cc5f0599fa7"
    sha256 cellar: :any,                 arm64_monterey: "247b797f86842225f065d360e79179117971e62ef73ea8cf596aaf83cb26de37"
    sha256 cellar: :any,                 arm64_big_sur:  "07d2c0050058be9863654a240e70e838d8d497851f1f2bc116adc423b39fd247"
    sha256 cellar: :any,                 ventura:        "ad2f10b7574d9345e0d012d022b28c0c95cc67f269ea7247a584476302c625ac"
    sha256 cellar: :any,                 monterey:       "f824b6be1e32a45bb94dbd71ead724e6eab26c37ef3f5b2347eaca9ed1159010"
    sha256 cellar: :any,                 big_sur:        "3fb17496bb13be70cbe441a71f77e61162bb8b01a3464d2792e8c72b1cfd31c5"
    sha256 cellar: :any,                 catalina:       "191fec3a0b20031d5197dadf5cd64b6e2412db945e1ae5538fd324f3d98b483b"
    sha256 cellar: :any,                 mojave:         "ea8524776d19e7dd04be3961865efae25e775fc252c9b28585f3da502a4b3d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec2f7c24c06aa55e01a60af4baacec6e1bb91d2804585cafb6096f8259409df"
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
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lGLU"
  end
end
