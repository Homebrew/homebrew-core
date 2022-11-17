class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.18.1.tar.gz"
  sha256 "5b004c121e7a39c8654bb61930a240e4bd3e432a80d851c6281fae49f9aca7b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fae2e3b3e49e198d644de5d41d1072b1eec914de46023f59cb193cc24611e8ef"
    sha256 cellar: :any,                 arm64_monterey: "a4cfc73e0e1cef6223f187f27ce34a503ceaa71dbed5d1a7e19763af2781b4de"
    sha256 cellar: :any,                 arm64_big_sur:  "1dd45f53ecf4aed0641eccf04c30c9369ce77748d4d243f0dce23cc166ef853c"
    sha256 cellar: :any,                 ventura:        "0d27a32c440fa6a4f065573cc681ca72b5710f7bdc09795631211b868d3495e5"
    sha256 cellar: :any,                 monterey:       "f692c4a3b61a4118bfbef17d689801b8e602bf18b8ee6ce4ad8cb1a1a45b37f6"
    sha256 cellar: :any,                 big_sur:        "b34d180813b2dec88159f38354f74c773814c0828a24cc10f81e0cd03ca9ab29"
    sha256 cellar: :any,                 catalina:       "0efb592a2b306bf3cc1da19e5ea4455230ef1cb3699b0eb50acd15fea111698d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9d579f863fb0da48795d2dd53df68de831b149f43a1281f26298bd893fc08f"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.10" => :build
  depends_on "llvm@14"

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

    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{llvm.opt_bin}'
      -DISPC_NO_DUMPS=ON
      -DARM_ENABLED=#{Hardware::CPU.arm? ? "ON" : "OFF"}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
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
