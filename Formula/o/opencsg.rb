class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "https://www.opencsg.org/"
  url "https://www.opencsg.org/OpenCSG-1.8.2.tar.gz"
  sha256 "5ac5df73b1ad3340dd6705ff90e009f1a946bb9536c21c2263a6f974265664c0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "362dad05f66ac74163331f99199b56325be26a434092f7fa5b4ae3485a8d254f"
    sha256 cellar: :any,                 arm64_sequoia: "cc49215e40e497c8ecf9e31963bcc1027f01265839bcc089c2a84a7d874e7364"
    sha256 cellar: :any,                 arm64_sonoma:  "8d2dc8f21f7d4189980665ad539bbeb3dc6bd0dac18897fef83f37d9e8ec2cf1"
    sha256 cellar: :any,                 sonoma:        "4f4b2a9ccd0dcac8ce40d638cc8ad040aa690ec690eb7cb052c00cc60d589124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd31ac04e11aef37ee2bc879d5936554265d50763da2bc77f488c867edea383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282d1a99124702682ac0b2e186d5b53b678989e1f72c0b8b7d9e541fea29963a"
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
