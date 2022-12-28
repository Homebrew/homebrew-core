class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.21.tar.gz"
  sha256 "0c949a6a907bc61a1284661f8d9dab1788a62770c265f6142602669b6e5c389d"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a5e7df101cf3d0ef05827fe521afc3b319a5fc542fff22475dfe7b311f2e9247"
    sha256 arm64_monterey: "75cd53aa1a41168c430052ec15772ad5a057585a74bf1019a4fae3f0b2073a94"
    sha256 arm64_big_sur:  "70099e79db01e8247fd509aaf7338ac4d1028d16f7796415f5811fc8f47714a8"
    sha256 ventura:        "87847fad2fede19f079254c98cf801b4816a8de00c65ad15774e7c783c987b50"
    sha256 monterey:       "65714f34e143981fde35fa14d4e3b5ccc03639824bf43299afd740e93307d4f0"
    sha256 big_sur:        "644584548446b58201b268ae991be28724ecd91d6b52597a62207f58546ad0bc"
    sha256 x86_64_linux:   "878b4ae134515b67119899e407dff987214e8a3ddbc56cf63fdae9dfed4a393d"
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
