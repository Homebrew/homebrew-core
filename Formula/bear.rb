class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "4761cb3feac7ee1f179f7cbfbe18229d0535c38595839d421f998bfbfdf095b3"
    sha256 arm64_monterey: "8a23fe11970ad452d83d71f29c2194709426873f0c6d7ef7fd0ee9562c56f9ea"
    sha256 arm64_big_sur:  "cd6ee26972e7e93f8a5dbc5dc1e09a2ebfe77e073837234bc3214ef33b23e87e"
    sha256 ventura:        "a39807fa3fa6421b7b2a1697cb6c9f732d6cef2ff5ba2360d1751c9d0cd54c32"
    sha256 monterey:       "3d5e2a6c0bdba60107b1929d7dafd7ec3a2433f5959084f3fd007c7c2166320e"
    sha256 big_sur:        "47f543dc49ea615d900f7d9a308214d9f24a2a781d8e6e7e343d1bea7027cfca"
    sha256 x86_64_linux:   "418f95aa196441ca6be9fc073d00ff10472a7f83412eddb0a5e108fb1d29b570"
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
