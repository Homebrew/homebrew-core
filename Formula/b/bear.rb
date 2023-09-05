class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b0f677b987556e04aceddf1e24fac60d39feff3f87b383421168ae7c9f847a05"
    sha256 arm64_monterey: "5d284bd4709b3ca61e169710ff0a5924b73087826ff5718e8445ffb61670df8d"
    sha256 arm64_big_sur:  "02d0fe7e8626829ee61dfaff59fd7fa36444105a205d31717f2f56b6ef391920"
    sha256 ventura:        "9a9c479eb0dfd100f32177103c4b0c8949f9b0ae7deb7b7fb454d44214b84bb6"
    sha256 monterey:       "bc58a943802bfda9ba35e349333bec36e9855f82518dec0af3a07cc2ad774e96"
    sha256 big_sur:        "8f76513ca24dbd051e8db40782ca5ede366a2de3b6f5b9a14583545cc9997445"
    sha256 x86_64_linux:   "60ba1badd46acbcf341c696707947d8d7a85e98edb649cd2cc10a5beba5f0927"
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
