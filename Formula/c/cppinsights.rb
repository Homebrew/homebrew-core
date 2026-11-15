class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_23.1.tar.gz"
  sha256 "2c2ac2f96612e8e789c96305031dd55af3d399a572989827d1657c388cdbdbb6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5633c0e313c6fd70f9410ffd5a10617ecbbaaa152713b912d5da69cfa814863"
    sha256 cellar: :any, arm64_tahoe:       "30982f0823a19c63dc716f05d93eaa5c7ac2597d7a31de8234160b90d9de5eb6"
    sha256 cellar: :any, arm64_sequoia:     "3e791d40ac93afe5c9fef513e43f01c5ab05dd6eb5bd98d5c95c9adfba99824f"
    sha256 cellar: :any, arm64_linux:       "ad14e8ac3e990a2361d68aeee61268b7c2df80df4df147191bfee0b858a2384f"
    sha256 cellar: :any, x86_64_linux:      "b8122edafbeda16ff1136088b5a8c8d0174340ec7e24ac48d11c04566141661a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  fails_with :gcc do
    version "14"
    cause "GNU version must be at least 15.1"
  end

  deny_network_access!

  def install
    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{formula_opt_bin("llvm")}/llvm-config
      -DINSIGHTS_USE_SYSTEM_INCLUDES=OFF
      -DCLANG_LINK_CLANG_DYLIB=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        int arr[5]{2,3,4};
      }
    CPP
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
