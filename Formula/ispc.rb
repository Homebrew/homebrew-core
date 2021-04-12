class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.15.0.tar.gz"
  sha256 "2658ff00dc045ac9fcefbf6bd26dffaf723b059a942a27df91bbb61bc503a285"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, big_sur:  "1ea73410e81f830f137d3aea93269480f821c417aa804330b4fe1d42e0df7b93"
    sha256 cellar: :any, catalina: "a0e3f1d9cd1abc2aefc1da0154707affcf44fef9646ec39379f2501e775bd87d"
    sha256 cellar: :any, mojave:   "cdfd24be494e49464be851a264d6db90e99f3a9d9f7d1241b050951c81bdd481"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.9" => :build
  depends_on "llvm"

  # Fix build with LLVM 11.1.
  # Remove these with the next release.
  patch do
    url "https://github.com/ispc/ispc/commit/0597a79d084c014780136da906afe21d15e982cb.patch?full_index=1"
    sha256 "1e6d887266ba643cd145c93531dc5d25877ff01c1674794a9eaae959155e7883"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/1851d18b213dbad169937076176b2d5509733c76.patch?full_index=1"
    sha256 "2864f74205cfc9871e31d7c029ec6eea2eff4f1b0ace52aef33d4f2a56e89c2e"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/c1d0a51bf8416d42144de9e2bdd59825eaeff1ac.patch?full_index=1"
    sha256 "533f16e10c1af08acbf800ed29228dcb2f4248ea521d7cda597383426d961af7"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/bb3f493d1fbd45c79e1d9dee67a0430ba313eaad.patch?full_index=1"
    sha256 "8c70d30d4f39e27b94ac7dc3a75cafe2d598e67a9d5d191f4db7b4174e0f23cd"
  end
  patch do
    url "https://github.com/ispc/ispc/commit/e3d1f1d69b87d37b6d59f50263eaa57c5d5616f3.patch?full_index=1"
    sha256 "39a61c403c124acf5fdbcdf90dc0edbdb6971ec50157a90f01d8ba6bd26e6bf4"
  end

  # Patch for LLVM 12 support.
  # Remove with the next release.
  patch do
    url "https://github.com/ispc/ispc/commit/1c0f89dccb774f216c7f6e76a99ee907a1e641cb.patch?full_index=1"
    sha256 "5113f8ad88ddd33e4cd9fb5acd76dafffae242b07e1e2b9c0ae57c38d461bf18"
  end

  # Patch for Apple Silicon support.
  # Remove with the next release.
  patch do
    url "https://github.com/ispc/ispc/commit/fd4063936606b1077296967dc031305ff28ee2b3.patch?full_index=1"
    sha256 "5729095bd6e5637602c654f5b17d461e518185e16ad41cf2bf9055b46e38de42"
  end

  def install
    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{Formula["llvm"].opt_bin}'
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
