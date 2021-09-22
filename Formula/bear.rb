class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.15.tar.gz"
  sha256 "a121ef68f58fdd0cc9fade11a98ae87c7d4d69cbf8d05b3c19624095d23b9a39"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "48b2bd5e46303c7dd4cdedb28d25127e03d5cec00f3456b4728c4992b5b399ad"
    sha256 big_sur:       "0ce5508b28ee29d4c12549a90851c706346af973009f74a05912112349afbe80"
    sha256 catalina:      "8e8e3f971f40c7437446d4e9d58e72d89d690b501bea378886020a50e1d76cd4"
    sha256 mojave:        "3d19f93fafcf129b1f7572f6e6544c949646c80357eed9fc63bc121672506e7d"
    sha256 x86_64_linux:  "a9b2b3c0eef25c08eb4d18247d6c3bf0d7199308afaedf661966b19899c5e0f2"
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
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
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
