class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.6.tar.gz"
  sha256 "0f8614f846390b16b890ffa84c7c925f4f684d10197633de02f0617f17d56cb3"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dad3d0febcbee87ea18e578287c750afe113f75b4ec1d9904e8c08566ede6247"
    sha256 cellar: :any,                 arm64_big_sur:  "e3e9f434c561890c1817c16f309e1c5bffc8e1faaddaf62629d8d074fec75433"
    sha256 cellar: :any,                 monterey:       "a0f8d042ee28043de9bc84901a0b81bfc0dcbf9dac70918e8278e48b6ad292a9"
    sha256 cellar: :any,                 big_sur:        "d2419bbafca11acea7ed7335b426b2010d321ac98dc7a2565d5855e1f338017f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7854747abed496f093f46f4fe01ef23f4031a798a574298bb369e90d2e486766"
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
