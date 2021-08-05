class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.13.tar.gz"
  sha256 "b57d9b139acbbad6439f5b1133266fa5afc5eb095a61cfa07cd9e8941943ae22"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "c4cec6a2cde957a3badcbd6c034339616ba4c3af89c87b2ac9336fd752baf83f"
    sha256 big_sur:       "f9fd3891304f105a3bdb3f398e28164f22f2393c4d38f06dfc2c8e2c80d398b3"
    sha256 catalina:      "c1eac851f134c114eb048127411ea3cf4e0d95a8320465af1e0e9cf106510996"
    sha256 mojave:        "b73a7ea2565372625fcc6acb324aff7d26ddcbe8e284b52b463cb0c968813fee"
    sha256 x86_64_linux:  "c6a4dbf31f2e9ece226d256fc2f26de511199074b5cf39b8bb4c55fd7d63770d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "spdlog"
  depends_on "sqlite"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
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
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

    args = std_cmake_args + %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
    end

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
