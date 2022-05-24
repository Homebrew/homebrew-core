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
    sha256 cellar: :any,                 arm64_monterey: "7d4d196ed149e1eb1e0fd705629cb9f076297e47aed98f1b9eef05e9b6f85db0"
    sha256 cellar: :any,                 arm64_big_sur:  "955c5a67864ff4eff48adab2af92c82d75df66c79c8c2341159975f3971c64bf"
    sha256 cellar: :any,                 monterey:       "304288ec34c1d0033d741d88d34647ffcfdf868f06ca211250b6a838e3e323ea"
    sha256 cellar: :any,                 big_sur:        "e179bb1855e3b3f65a32165ceb840334a5100e8c066b2e41a2ef9e084a877e8d"
    sha256 cellar: :any,                 catalina:       "79b0a215f6d86cfcdf071f5c7058bcbf12bb4f18fe1894fb4ecea4a6a81d7fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7c5cd017e6c1e637bdc9d2fb797fcf0a3f9f348263b8685f25a3e60377fd8e"
  end

  depends_on "qt@5" => :build
  depends_on "glew"

  # This patch disabling building examples
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/990b9bb/opencsg/disable-examples.diff"
    sha256 "12cc799a6352eda4a18706eeefea059d14e23605a627dc12ed2a809f65328d69"
  end

  def install
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
