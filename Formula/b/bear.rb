class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 15
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3ec34cc26bd378a03f7a8d39bfc2938e95daeaf8a676f9a1f40cfd326a65ab4b"
    sha256 arm64_ventura:  "1b064cc7045d50a698e4bb465fe2c58709d214a3badedd54b41fdc6d68e46ddc"
    sha256 arm64_monterey: "261ca31154f098b16e2f21d55bccefd687a6f2dae19a628e1c3bdc573c98cd96"
    sha256 sonoma:         "c9ecd1ebd249cdd2e2011773c124d81ea481b2c57a47794bb1935cb50fc94c50"
    sha256 ventura:        "81ea06357e17422b77d77535a5ff741584494f8244fabba25b3ad25237bd9972"
    sha256 monterey:       "a2a7f3efb0ddd9e078267994c655fa64a028584283408511f37accad899682ff"
    sha256 x86_64_linux:   "c3c726b8136dc30eeed749124b13325c009f4c1f9d3499ba1ba75da696dad71e"
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
