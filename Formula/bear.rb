class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "69c78bbfa80a5e560c82ebfae3f6a3b6dcfba81a0c6b84714022a8796e95b0e1"
    sha256 arm64_monterey: "5d2ea9457f817568c8fd48c7c8a5c031e51cc0c97cb00a076118776cfbb29939"
    sha256 arm64_big_sur:  "b74dd5c017944ba50468cadb06f86157293f9d080e1bf3ad3c0a06efb76bb956"
    sha256 ventura:        "22605bb08564f5f2c5d4b74fc40112fdccfc5e01546b8fd4797ec9585c35101d"
    sha256 monterey:       "5fed9910ccdd9c31341d4160bad41497eef903e03c49f7b7b40871b68222fcdb"
    sha256 big_sur:        "e1186e095ad6f91e87791a67955d6b9b0f3559b6d64b605bc5eac36d2b2c1bf4"
    sha256 x86_64_linux:   "fc373f4856a65ee6246b1ddcb0cf3bf50f7454a789f13fc2697c77bf1616483e"
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
