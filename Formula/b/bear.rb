class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "de84f1f8b481d82cbf1a37ddac490ee05e511b4e18fdaa197aeecb3b02af2cf8"
    sha256 arm64_sonoma:  "0e9c4d2a3133e4cf348c2e87973db013d531d79c43ca9d58941a5565f77a2e8d"
    sha256 arm64_ventura: "1328da7fed6320ed3357eb3e41ddc47a40bc7533190e38d476f2c509c84e4728"
    sha256 sonoma:        "9fc488f9ca375ace1aebb3edd01e9c9b6f124435e26efeed7986ef7b65095532"
    sha256 ventura:       "2cd213b80fed473a2d5e6b9acc6a7755dae150c68984d850f5e88285c7d69610"
    sha256 arm64_linux:   "27537347ae7d786c556f92cffcb26f9e7c0431e6798e7f1f54387e70a2ae572b"
    sha256 x86_64_linux:  "979b1b5efa8f8a9ca65008d00ebb9c65f8567e64ae74f9db277867641717d21f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
