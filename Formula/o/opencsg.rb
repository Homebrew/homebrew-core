class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "https://www.opencsg.org/"
  url "https://www.opencsg.org/OpenCSG-1.8.1.tar.gz"
  sha256 "afcc004a89ed3bc478a9e4ba39b20f3d589b24e23e275b7383f91a590d4d57c5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e0073b1a6fe39d878a4066d957dbaf09fb7c874d726b4e61745740881aeff69a"
    sha256 cellar: :any,                 arm64_sequoia: "b0a69f125e5ccddc9559b3d088e44f7080a4a88903092db4a5d8cc45b2401eda"
    sha256 cellar: :any,                 arm64_sonoma:  "baabc5f08880e3740596c333b7d6736edbce5d4c56374d8310faf71b4b25ec75"
    sha256 cellar: :any,                 arm64_ventura: "4c6433d8600f7037d2cd0b4e59b18a6d100afdc9940673a5b404fe7ff18964c1"
    sha256 cellar: :any,                 sonoma:        "b5568908930ffddc71dc9fd5d1689da95250873d8a7d510b52c9a725ed35a791"
    sha256 cellar: :any,                 ventura:       "4194e7de3bd9c4a7e16310247e47730302c95d0e43383a9b72a5bbd35243a544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d903d2e27437f4817f58160125a8955b7b1daafca1150c446c7db65601553ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb20cacd22251a2ea4a3c4b9549a78c51f8d32e98175f41f7618e78c3435030"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "mesa"
  end

  def install
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
