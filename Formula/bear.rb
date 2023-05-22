class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "43988803985f93907776b0b7175ec5768e8f3571625bfbf46e48955b52837244"
    sha256 arm64_monterey: "83d37bab8ac9f9dea185c6333aed9628007f74c18d9a3fffb79d1d778702aad7"
    sha256 arm64_big_sur:  "82f2f9479bc8ecbd06cac77a7b022f7735a88ce0e06d27b7eef074fae03a5dfb"
    sha256 ventura:        "ae1832fe68e746b871db88b59c49f078d3dacab288330df57224187771ac5531"
    sha256 monterey:       "535442a3b12aaf45a54590310a17a5f22c2cacb4279e63c8dc705808c68f1121"
    sha256 big_sur:        "2ed1231d31c6e7d70da9a193e23f9d9d14f53bd98eb9f4fc64a17b3a1c6fa1c7"
    sha256 x86_64_linux:   "ca24be7b535bf242c8fddc2d37f1f9725e750ad7ce012c3213baff01208daafa"
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
