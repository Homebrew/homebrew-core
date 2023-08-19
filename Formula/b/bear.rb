class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "fa19be74445bc3ec4a0b9c1f1df2efd735076b1db7442ce8949c0b892c946a96"
    sha256 arm64_monterey: "e4dba78bf7e41f0a5451444e7df10b6fb5f0f76c624848b6c7632cdac2277dda"
    sha256 arm64_big_sur:  "320eeef842433d2dc2afbd10d5a7fff0aa338c0bfc1c2dec34982c8ff8c32fe6"
    sha256 ventura:        "217d9788adaaa5990c2a731328938f5cdd155d914657d79dd4166e516516039c"
    sha256 monterey:       "1f5a5947dd0652cda86a285c113fd79bbbe8e42058def5caf84b4911a467e63b"
    sha256 big_sur:        "7b9381cc719cf6c68aca49d599f295403ba81484ac7213469719c84965d109b9"
    sha256 x86_64_linux:   "ae7c5ff9227dbe6b3af8b585180c8da4130d66374ee01ea2ca5ca4a5b42d2250"
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
