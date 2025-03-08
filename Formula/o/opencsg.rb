class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "https://www.opencsg.org/"
  url "https://www.opencsg.org/OpenCSG-1.8.0.tar.gz"
  sha256 "cb2fca02f73d9846566a97cd40863a68143a141aff34c75935be452e52efdb10"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3593c6eaad9f71c123a0812369c2e73d8ba7b130e83d9d8260580ce931e6e688"
    sha256 cellar: :any,                 arm64_sonoma:  "df8adadeacc94919520029a57d1aea0bc10cce4a3283ad8c553249e60111b699"
    sha256 cellar: :any,                 arm64_ventura: "877b8b0e60156bf6b5dbf7ac59bf985009feac839253357ad6053294ebec072c"
    sha256 cellar: :any,                 sonoma:        "c8988828a3e4baf9a1111262498e0253fb30af2b5fb9a0100cb94f12f188d45f"
    sha256 cellar: :any,                 ventura:       "bb2ce70f809a01ca27fdf9a3dd6cfc0cc7befb4d3811cc76e8e8a3735b5f68a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ab095beec175e194a91f8ee2cdb4019c8e62e639f3f3bf8d52dca372d1e903"
  end

  depends_on "cmake" => :build
  depends_on "glew"

  def install
    # Add GLEW configuration and linkage
    inreplace "src/CMakeLists.txt",
              "find_package(OpenGL REQUIRED)",
              "find_package(OpenGL REQUIRED)\nfind_package(GLEW REQUIRED)"

    # Target "opencsg" links to: OpenGL::OpenGL but the target was not found.
    # create linked to GLEW::GLEW
    inreplace "src/CMakeLists.txt",
              "target_link_libraries(opencsg PRIVATE OpenGL::OpenGL)",
              "target_link_libraries(opencsg PRIVATE GLEW::GLEW)"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXAMPLE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
