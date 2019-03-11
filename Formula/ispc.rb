class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.10.0.tar.gz"
  sha256 "0aa30e989f8d446b2680c9078d5c5db70634f40b9aa07db387aa35aa08dd0b81"

  bottle do
    cellar :any
    sha256 "d261ff3443392575d7f5b48aafa167bde7c2963817075f6d995324e86af3b85a" => :mojave
    sha256 "f9bca3610d861511fb451c14332a60f9f19d54382b46e8f1a8edc5b92ff74c3f" => :high_sierra
    sha256 "7a5b35df98fcc48e2cd774ce76b357a8fa929cb302d3b274a7479ecfe3ba45dd" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm@4"

  def install
    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{Formula["llvm@4"]}'
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
