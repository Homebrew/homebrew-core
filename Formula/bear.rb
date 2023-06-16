class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5ffc96ed413ed0690fd88c51eed4548a9f8d964ffaba36e0f460a7fb8c0d809e"
    sha256 arm64_monterey: "de8f970465ce20ed57b9fc4d1fbe2cff45e8c7017caf6543ef8d010548a2b896"
    sha256 arm64_big_sur:  "08db39c3ab6f105b90ec84788b92a17d755652e75c383ede8b14ec374eefdcec"
    sha256 ventura:        "36ce0e4314bcffce0fe23bef5b9f69417f3e888e979d357dcbc0d8125ec167c4"
    sha256 monterey:       "db080248349a6e2b8ca368ffaaa102335f309a1c90b51937f9fee8efedd2a389"
    sha256 big_sur:        "c3482c88913ec3fb8add788898ff39ac8c15cc294ad70996fa0ed9488e64ba43"
    sha256 x86_64_linux:   "d05547e91dd5dfc9c77d33dd13946f1d1fd085a5a87d69ed068d30a43f0c80b9"
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
