class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "64ad759006cd2377c99367f51fb36942b57f0e9ad690ed41548dd620e6f6c8b1"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ac174c6809d89d00a4f87e7aa3d1f837aa1359f79a8c9965bdcbc329903a22dc"
    sha256 cellar: :any,                 arm64_sonoma:  "38366b01d1aab1b30a020edc70367717e160db9f801150a5e000571bd034cc3a"
    sha256 cellar: :any,                 arm64_ventura: "9da5361dedc96d60cea7e7f8b7fb1cba3dd9b4151a4cafbf6142ecaa8483cf66"
    sha256 cellar: :any,                 sonoma:        "856209a34ff38af5618ec21f2b2680f564eeb85ef313bc498c4063c6965ce691"
    sha256 cellar: :any,                 ventura:       "b88e24b021259061e7c0037d233be09bff0a9c32209abf2684f662fd64f7d3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d264edcb343f0271dbcc1d5b17f81f29af2650a42555fefe04a8208b4f010693"
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
