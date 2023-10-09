class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.6.0.tar.gz"
  sha256 "bf8fb80e3e0ce11d87dd78dd15a0de872dbb8972d87f5f89cffc461efad47be8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a241be0205cde86f48054be64523ea937ce7e582a7b1914e5420c2580bc36e7"
    sha256 cellar: :any,                 arm64_ventura:  "4b28b76bbfd8ff4c7e248ecd4002a2acc7b642e70097a4573ba1a3e35586a493"
    sha256 cellar: :any,                 arm64_monterey: "133b6c6a4bb2c39d3200e7af4d357ededd3473f5ae8361d9e27508b7dcb562c2"
    sha256 cellar: :any,                 arm64_big_sur:  "e40e2cf3cd9781f797895f6f7ae44e3a8b2240b33e28f0cad82a1ad830a6cc39"
    sha256 cellar: :any,                 sonoma:         "e980e159aea7fe4e918de12663b4bf187d62bdad392761d735d7a813c2d0832f"
    sha256 cellar: :any,                 ventura:        "b25d9df8d91c852e769bc73b53121900ae76abcc20d4ff78777c886324dff26c"
    sha256 cellar: :any,                 monterey:       "ffa1192d5f9a986429848d143730f89ed23f6d322fd205256aefb813c3d869a3"
    sha256 cellar: :any,                 big_sur:        "2f722c11994df3bbf13077eb32877ea18600f92003434b61a20bcd6331297ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3fc35ff3b4f3617a45eb3a86a6e2dc5f9e510808ea088172eb2b9aee3c1546"
  end

  depends_on "qt@5" => :build
  depends_on "glew"

  def install
    # Disable building examples
    inreplace "opencsg.pro", "src example", "src"

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "-r", "INSTALLDIR=#{prefix}",
      "INCLUDEPATH+=#{Formula["glew"].opt_include}",
      "LIBS+=-L#{Formula["glew"].opt_lib} -lGLEW"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencsg.h>
      class Test : public OpenCSG::Primitive {
        public:
        Test() : OpenCSG::Primitive(OpenCSG::Intersection, 0) {}
        void render() {}
      };
      int main(int argc, char** argv) {
        Test test;
      }
    EOS
    gl_lib = OS.mac? ? ["-framework", "OpenGL"] : ["-lGL"]
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg", *gl_lib
    system "./test"
  end
end
