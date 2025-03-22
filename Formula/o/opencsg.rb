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
    sha256 cellar: :any,                 arm64_sequoia: "f92caa541b802161c2c60e745a49574ba379dcd40492dfb2cc9c4e123c89920d"
    sha256 cellar: :any,                 arm64_sonoma:  "07b56281fbb460cadee1c2117d80a52d3967069363af998d99c7f2dc46ef1891"
    sha256 cellar: :any,                 arm64_ventura: "e7ca2f7b0365b03aeea72adc6e87c80d8153f07bef3108fdc56eaab0682ad6c1"
    sha256 cellar: :any,                 sonoma:        "89f9db42762d2ab1958e8bd5654c4f46644a1a831e1966f3581932925ea2212a"
    sha256 cellar: :any,                 ventura:       "2c2c3b7ba27e8ee0190776fa0f35729e4bf0d27bb7d581e56f3cdf62d1d95fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6dc9589d54eb362645b8563f62c66b5e29bd44c50c0c4c483db011b3aac5ee5"
  end

  depends_on "cmake" => :build

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
