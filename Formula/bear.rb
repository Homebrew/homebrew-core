class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.11.tar.gz"
  sha256 "3f426b5b22cab1ed6146aaba1dd612cd387b7298915ca58a72386bc8c1c9d9da"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "b1366ee18864d28920459b4b9d65a4166ff3e498030e82617939b6ffcc9fce66"
    sha256 big_sur:       "9c2c172d9d5873d7c38d3886b49b8836c7994ca55a1a98815a0825640a87c5c7"
    sha256 catalina:      "311d92869dbfb48a30c949172d42f7f7c26f28b7eaa6e682d1999b9e2657bfe7"
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
    depends_on "llvm" if MacOS.version <= :mojave
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
      ENV.llvm_clang if MacOS.version <= :mojave
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
