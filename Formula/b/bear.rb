class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 13
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "a23b54a98e34b9bee03c1a9dc202df85795c2c92fc2f8e3a7298b496b805cc3d"
    sha256 arm64_ventura:  "b773b922a11922d3fefb0984146dfea1b260848812fe8c0fc4265cdce92c1776"
    sha256 arm64_monterey: "c59656c1e7591313e8433e8cc209a774aa86d7321590eb8c239361f0a1c3b714"
    sha256 sonoma:         "df815d6c5f98308c699f006af18a60243ad3f5b193b892091b75a06d286cabc9"
    sha256 ventura:        "e2de5a7f3a771c08426c60f32f286ec85cfee1c344f2b48a1d90f0d7920b809c"
    sha256 monterey:       "5d7303d32fb75e4c034262639a4e55030278ed76bfb4f888f022fb94af68acf4"
    sha256 x86_64_linux:   "93530eba69e790e6a9f0a91eaec75397a115cee375f553aaf392a14a540968ce"
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
