class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "f75b26894af1429a3dc6929ae03e2c9e99bb8c5930eda14add5d2f6674db7afb"
  license "BSD-3-Clause"
  revision 1

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ca65ff11543bb326b81d959a0edb4223098d6f9d735733ee004816574aea051"
    sha256 cellar: :any,                 arm64_sonoma:  "8e37e253863a335c144afaa6f7b159a9dff376fa874db90e9a9fca54ed9408f8"
    sha256 cellar: :any,                 arm64_ventura: "fee375a66b0d659a61a8b8682dd46f938e997a78d0b228f6ebea5ef17a81175f"
    sha256 cellar: :any,                 sonoma:        "1741872fdafe79dfbd305382c122a2a7a7cd849d06fdc0d8ca8c1d9860075d19"
    sha256 cellar: :any,                 ventura:       "f3232ae325e47ed4a131e06f7a33c7c45428d9fd59b9da0b56bbcea6a626a766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b5e673cf3ffccdabf4730cb099907f9ff73375e867dae4fe13446bb96394e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701d608135443f6fd38f019c5a7a993214bc395e3c14005d074a8261a8dd795e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  # Backport commits for LLVM 20, https://github.com/ispc/ispc/pull/3286
  patch do
    url "https://github.com/ispc/ispc/commit/d8082c8e73a7998d2d527c1ac87d5acf1d35aba4.patch?full_index=1"
    sha256 "f21388d50719bf282b161a59a3dba4b6cb8b4f4b3be5fb88c501a63086566112"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/26e0c53ee7e3639fe37f796ebc402776fd5ac771.patch?full_index=1"
    sha256 "66a5148a1baf02a64c52faba61094ae186001b7a2595ef42b7b88a05d423301d"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/2e7b817e1a4dbb623d922eb5eec94749002e5585.patch?full_index=1"
    sha256 "44d4ee4c256180abc9590d640c5fe3d1175102fd9365ab1976a45c64d1ef81ba"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
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

    (testpath/"simple.cpp").write <<~CPP
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
