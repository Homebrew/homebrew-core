class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "963e8be3cf1e9c0c77f750853698a36c23f8bb1280f02ad3a3a26d01e856d427"
    sha256 arm64_sequoia: "d01893bec62857a49a9caba029722bf984a19b6e16308e4587f222b8948e2e99"
    sha256 arm64_sonoma:  "ffa1c2fc25956191f7360e8e43d5beb694b2d831868034def10de99f44dd4845"
    sha256 sonoma:        "02577631912e8b7e59cfaca9d85865bda80af6b161ec170f694284bcae01d86a"
    sha256 arm64_linux:   "2c4a7a4ca0ed27aa4a8c20ca268961878baf6aa274686b90611d3146e2cfd8b6"
    sha256 x86_64_linux:  "9356936c7207aca92721f6a018f5d9fbed9a4659738f7d1408ba7ec1681f4a24"
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
