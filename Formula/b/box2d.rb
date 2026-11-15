class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "ffec747b27a2267016f8d0240d658c82d187fb2271fa0f69fcbe53fbc067180d"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "991be5146a3a25da927d8c4f8028d25963110f9337194513148e1dbde2a9df06"
    sha256 cellar: :any, arm64_tahoe:       "66e4ec0b3301827584a4368f83c97cb60c7a8f5ee7f56c620f55c5ceaef61dfc"
    sha256 cellar: :any, arm64_sequoia:     "16db3bc4c4c69548e15a8bc7e3a52d555ea9d996c550b4987ab7ebf3afc70815"
    sha256 cellar: :any, arm64_linux:       "3ef098072333caf4414deaf39d3bceb0ef76e26461552c5ae8b81ad8f6d348d7"
    sha256 cellar: :any, x86_64_linux:      "a81bbf4a35149df9bb1ad77056047df559ad50415397fc7cd0abab92140c6040"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
