class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "e539b053ad882c28790f661af61bbe11209dd9752764a60ca6fdbc2cdec687c1"
    sha256 arm64_monterey: "4edcda6e8abdec8316b26ff254e6cf9f8753d9d7b3fa5b25a7703e48666f6587"
    sha256 arm64_big_sur:  "0e7f7deb691595aae17f3366c5f7f2d865b8a833e562b1664b317a7d4ca300ce"
    sha256 ventura:        "ea98d57c088a96a88ab352f7dfaf9817f8a21094e0d50b435fdfeda2f9ce2297"
    sha256 monterey:       "3cb56683feddc7975d784d23432cb8210ccf0408eecf20998590a7d2df90058c"
    sha256 big_sur:        "8725fa31fe5be315e1fab3ddbe64f25ff4be155a25997db51f0b1cbfdb839e11"
    sha256 x86_64_linux:   "7cb9b233cd53388858cb62f67af0b2eaaec15faeba8d1e1fcd495c050742d3f0"
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
