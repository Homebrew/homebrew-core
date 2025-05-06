class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "7fac19801485efb31ee3745b2284d9d4601f9e8138a3383a7b0df6d788ea5785"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca167fdad8578916d77f274b8a83b3b1eb09c651cd28b4fddc37ae35082a683f"
    sha256 cellar: :any,                 arm64_sonoma:  "55a7a318fbb28367b04a41ae6321e17a230ee4e0ec2ab87693d14b630c7a9718"
    sha256 cellar: :any,                 arm64_ventura: "168cca17b58980ed81cee2a9221a347f38c65d1e39555918e0f6c16c166be08f"
    sha256 cellar: :any,                 sonoma:        "e9c5c96016ece85eafd692cc058a1170ce8e50acb199e061eacba77209e41af7"
    sha256 cellar: :any,                 ventura:       "4402f7762cf3d7cf97bd0a45e5276818d448818e74fe8266f016bfe465d852ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555b3df11035a1d7f5106fa381c79536cfaf5475143112fde68275d5bcc1ae6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d587630b9e3b860821d03f88fcbb9e673531815ddaa615a55ef20ec64faec9c2"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBOX2D_UNIT_TESTS=OFF
      -DBOX2D_SAMPLES=OFF
      -DBOX2D_BENCHMARKS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <box2d/base.h>

      int main() {
        b2Version version = b2GetVersion();
        std::cout << "Box2D version: " << version.major << "." << version.minor << "." << version.revision << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lbox2d", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
