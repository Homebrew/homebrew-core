class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.21.tar.gz"
  sha256 "0c949a6a907bc61a1284661f8d9dab1788a62770c265f6142602669b6e5c389d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2e1ea659faa25f72699dc18fddb2ba94cf830e6f8ec0a8f420278af0322f784d"
    sha256 arm64_monterey: "442a24307ffc80b66328f21c49ed846c8ddb6a719f86d5ae22ba0be25aa1bfb1"
    sha256 arm64_big_sur:  "af19091aa24fe6f5291ffc0eae8d023768736d95ac403c0ec4031d02f0a4bc9c"
    sha256 ventura:        "110a527130395fa508793e5798eb5f77887dd4ae94375c8b4d70fee10ce8109a"
    sha256 monterey:       "a681cdc34e7bb4b877524cd7329fc8abb4f741ccb5d0589094d226a7d77d4827"
    sha256 big_sur:        "c5655ce2f9dcdd598b5e03a7054cb264c8795b80e7cb11f8670685d3d33618f3"
    sha256 x86_64_linux:   "9e6d824f091a1c49067d1c67d34ec6ac011936c4d95c9c73b006a7e510f87991"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
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
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
