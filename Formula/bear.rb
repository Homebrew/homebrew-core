class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.1.tar.gz"
  sha256 "52f8ee68ee490e5f2714eebad9e1288e89c82b9fd7bf756f600cff03de63a119"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "3d64a6a729110cc5bef3fdb9fb50e0a02e393b2da6e38392856c6c7937518f0d"
    sha256 arm64_monterey: "92f2f95335b917036643f533170dcb2d2dca61c90b1da81f7eec36b531e6d91f"
    sha256 arm64_big_sur:  "7891fb98549a50cdae1cc07612dc8aac1bd367996eda1bb5da55daea411de089"
    sha256 ventura:        "efd84ebd695fbd02317d8db2bad632ab3398464a11ebce2e3873fb19e21cbad1"
    sha256 monterey:       "7ea19244d271abbe11b2ab92d8b368bea4cfdf067a52cfa2259407629c1a975b"
    sha256 big_sur:        "b76af8309382735038adc6f150fb0f7f553c5c35a28452f8b1e4bdfb81923b01"
    sha256 x86_64_linux:   "9a33a4d25bbdef42d9eda5dd901a67e362b41cd52d837ba1f3dc472c3c64ab2e"
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
