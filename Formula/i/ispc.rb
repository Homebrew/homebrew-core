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
    sha256 cellar: :any,                 arm64_sequoia: "8ea0319369588dd8a1ae49ceef5bfae7d1f4a1ee662a232212a194bdc0cfba75"
    sha256 cellar: :any,                 arm64_sonoma:  "da000d5a68707603b12600beb3d6b9c68c8415216bb254d30dd7309cd97019c2"
    sha256 cellar: :any,                 arm64_ventura: "879ba81d4d347247e3ff447b562fa132746c3f307d65a9039389280788890528"
    sha256 cellar: :any,                 sonoma:        "5fdfceb7ec3388c2eef20156baf619a75b2038d1c6dcaf962936ed303610eea0"
    sha256 cellar: :any,                 ventura:       "ca9fa25ca9e9362c370aacae054959c9118a367a478148c0493f22f9835b86ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488bdf3076fa35a278b9cd36065959c44eddb16e15fe690e649a278f4d2bf268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812244939a24ef3d938af983d68ef6a16a522fe798ff4c0565dc5c6e56d47f41"
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
