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
    sha256 arm64_big_sur: "293b7d941a86287e7a16e204d23782e2382b8aa63bffbf62c058b5d51ece75d5"
    sha256 big_sur:       "19e053eb89067c18505711efa5608e582627e0faf03fe7bd48860d6c8ef2f96f"
    sha256 catalina:      "d06cb81ddb0500de3caddc7d8edb6b07d97cc65e24a73844f3c7273aba859e4d"
    sha256 mojave:        "87d82fe3dbbe37961a33cf5c37c9a70d21698240b5599a11f5b49e8c0f06201a"
    sha256 x86_64_linux:  "026104e7bcfc9648f55b1e25bb574b57e533b127492af3bf54c536aa3651801e"
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
