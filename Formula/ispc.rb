class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/ispc/ispc/archive/v1.19.0.tar.gz"
  sha256 "da1eccb8ead495b22d642340f3bab11fb64dd2223cd9cc92f0492f70b30f34b5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e661d50f1b5cb0cdfd316b64e0f76654492c034229312a9e781be94b32a931b"
    sha256 cellar: :any,                 arm64_monterey: "e1bf03b9d3b079e7c10197290aee69703f8674ea927ed48c26287ced7df68283"
    sha256 cellar: :any,                 arm64_big_sur:  "378e72bec0ee7fb08e5c7604064fbe28118b7b79002126523a9515ef86d7cb4e"
    sha256 cellar: :any,                 ventura:        "bda3911e8e05c404d558daf52eee06f4ada9a23bc0b9936ec2894c4ab3fed3a4"
    sha256 cellar: :any,                 monterey:       "37a2c6b42aa2cbe07c4fc2c9ce0fcfba3b3f8589bb5747c81a01099b138a1ca2"
    sha256 cellar: :any,                 big_sur:        "7693ea70bc6584a6f383611e8600349614c871764fa0962efad2266e9278b618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5133fec2af99ddb66c1768cb028307f51a9456ffeabe69fc4c2fe1183d661d3d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.11" => :build
  depends_on "llvm@15"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmake/GenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

    args = %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR=#{llvm.opt_bin}
    ]
    # We can target ARM for free on macOS, so let's use the upstream default there.
    args << "-DARM_ENABLED=OFF" if OS.linux? && Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"simple.ispc").write <<~EOS
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    EOS

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
                       "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
