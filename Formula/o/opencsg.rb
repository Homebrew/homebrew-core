class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "https://www.opencsg.org/"
  url "https://www.opencsg.org/OpenCSG-1.7.0.tar.gz"
  sha256 "b892decc81a9e67c2c4d25c5399d576d8f77c3b0c05260606743243c86539df8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "2d11f1ed5484d470c5c4b778f5a701ceeeb25824974a37b64042e82468e247a0"
    sha256 cellar: :any,                 arm64_ventura: "12506871013066efe79df98003d9ea88f3e062ce41fd50050d3cb8a9f97b1824"
    sha256 cellar: :any,                 sonoma:        "4d6b69483e82838a5e113cd9808e32276e2d0434b40b4a7c790576ffa1328737"
    sha256 cellar: :any,                 ventura:       "9057d05b831616e9b8fe6a74c6aa018a6a9481dd8b888773241f06aefe49b882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37ea3b9c6749f57cf8b91102f334a161b707a27e9c5d4f939ea946b445207e0"
  end

  depends_on "qt" => :build
  depends_on "glew"

  def install
    # Disable building examples
    inreplace "opencsg.pro", "src example", "src"

    system "qmake", "-r", "INSTALLDIR=#{prefix}",
                          "INCLUDEPATH+=#{Formula["glew"].opt_include}",
                          "LIBS+=-L#{Formula["glew"].opt_lib} -lGLEW"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <opencsg.h>
      class Test : public OpenCSG::Primitive {
        public:
        Test() : OpenCSG::Primitive(OpenCSG::Intersection, 0) {}
        void render() {}
      };
      int main(int argc, char** argv) {
        Test test;
      }
    CPP
    gl_lib = OS.mac? ? ["-framework", "OpenGL"] : ["-lGL"]
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg", *gl_lib
    system "./test"
  end
end
