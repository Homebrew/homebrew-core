class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 12
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d48e6ea15ccc86eb4d84ff49f2191908392bb9a0296580a74359a3ee9005a814"
    sha256 arm64_ventura:  "c600a2bc2de33da224bc538d1e328fae37e8c7a813304d88e76ff1f5e7c54bdb"
    sha256 arm64_monterey: "cd572b707d150e75b3edae341db35174fd1e985ecd7da3cb06b2cbbd1fea3137"
    sha256 sonoma:         "5f0ed84bf95fa9251072fb6e4c1e9eca3238b6f3e637f35627f6c7a73747c422"
    sha256 ventura:        "0ea04ec1a8c3084b7fd90d78153601fd6280f48e64e3ef330ef88d1f19aa20a5"
    sha256 monterey:       "b5d50cad33c186d007383fc23a590d52751623e61fe14d7870f8980eb0cc5e1d"
    sha256 x86_64_linux:   "bc3a2e952e7eb19445887b8aa08f3ca3b00ea8e063858fcb6358c0b9c9be88f6"
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
