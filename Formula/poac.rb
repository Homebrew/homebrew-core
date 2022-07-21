class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.10.tar.gz"
  sha256 "faadd38212638887effd129c282b3ca38e082c77a0a0845d9c11ca5600b44ba5"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16ace121f8b7235c3ae0d64c23708de2fa6937cd1f61fdee486a9956b3719f79"
    sha256 cellar: :any,                 arm64_big_sur:  "297352b2afdcf77d21ae7cb63b8d6db5e597b71691e07ce608af9e65888ee044"
    sha256 cellar: :any,                 monterey:       "5c61cbf849e9dae550568583a99e20b7c9e8cb6d959a39e9c46a099d06034439"
    sha256 cellar: :any,                 big_sur:        "f6ed9bb3fa2cba03c382f317b0c41f8ad971a5d60bddaa1d810f9a36c5c101e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337578914c0b9d38a5688d65cdd2af699b63d9bad0c4d7cea2579fe79e8e8b67"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "spdlog"

  uses_from_macos "libarchive"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "5" # C++20

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    system "cmake", "-B", "build", "-DCPM_USE_LOCAL_PACKAGES=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man1.install (buildpath/"src/etc/man/man1").children
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin/"poac", "create", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
