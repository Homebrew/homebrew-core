class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.10.0.tar.gz"
  sha256 "0aa30e989f8d446b2680c9078d5c5db70634f40b9aa07db387aa35aa08dd0b81"

  bottle do
    cellar :any
    sha256 "69c12c8e3a068b9d3c1361ad5af915316875d50ffd91eeca03d54de81692e4fa" => :mojave
    sha256 "3aed8cf86cb9cb7329b5fcb5cb81fae74d2d5fb61bc65b5e6d36525b0f7ae12c" => :high_sierra
    sha256 "21ecdffa7a0594da5882b01c83b60d17e97d588fe5f676d87fdc3d0491039592" => :sierra
    sha256 "403bd415fab378038524a4981c4ac21aac6bfa72b77348a454d89ef27b554a4f" => :el_capitan
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
