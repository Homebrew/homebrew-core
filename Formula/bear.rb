class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9a547a12452bb7d9c9302d97d5c61fd1ad0bc4b04bcfe0c97d6268efccac7d5e"
    sha256 arm64_monterey: "ebeefdbb93c63de26e4abe08e42adf4db47a97085cfc25d5d1bb428bf3ef517d"
    sha256 arm64_big_sur:  "d3f2ef7b574bda541548ea9ad2f4b6b36e4a87d0355a211c969d25bfafa546dd"
    sha256 ventura:        "a6697ce9723ab84e119cc156fa130cfe16adf48a7d63769c716f01141a2b3055"
    sha256 monterey:       "28144d77c14bdc596670b50d19254ea0fe165d69a1797059b16fa8ba3fe9253b"
    sha256 big_sur:        "b0d7bd269a509510232ae749fc71f0eea0bed45e4af0df6aa7447b5bacafdc61"
    sha256 x86_64_linux:   "c5d3ed980500b8f3169ff84e8690d7753da583b61e015a3398db1fa90dd2d1c7"
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

  # Add support for fmt 10
  patch do
    url "https://github.com/rizsotto/Bear/commit/46a032fa0fc8131779ece13f26735ec84be891e8.patch?full_index=1"
    sha256 "af2a1bb3feb008f2ed354c6409b734f570a89caf8bcc860d9ccf02ebe611d167"
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
