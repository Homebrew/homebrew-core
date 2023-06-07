class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.5.1.tar.gz"
  sha256 "7adb7ec7650d803d9cb54d06572fb5ba5aca8f23e6ccb75b73c17756a9ab46e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d81b7b99ecf0f9005bb7ad7e5d620a69bd616e26149acbe75f5a93207e54ebbe"
    sha256 cellar: :any,                 arm64_monterey: "d81b7b99ecf0f9005bb7ad7e5d620a69bd616e26149acbe75f5a93207e54ebbe"
    sha256 cellar: :any,                 arm64_big_sur:  "c25ed441e4839673e8e498fa668876dee9f969f47a0ced101bbb0657aa7e2b08"
    sha256 cellar: :any,                 ventura:        "e1a7e587d9b66b0a23184e0ab3d3e9df41424fe7a9615bd13432affd89a133fd"
    sha256 cellar: :any,                 monterey:       "e1a7e587d9b66b0a23184e0ab3d3e9df41424fe7a9615bd13432affd89a133fd"
    sha256 cellar: :any,                 big_sur:        "065b62d0dd08a2dd656ca87a615465efd114ee2a758d3a31d4c387888b356fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c66be0ffb9e3fee24f1942092ef33340e92af64a71a170cbdb2ee7f599af2c5"
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
