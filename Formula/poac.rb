class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  revision 1
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1afba3c3f77ff0bd2d84927b83eeb80b417c30a9a24912b86a6d96977cdef2ee"
    sha256 cellar: :any,                 arm64_big_sur:  "f7343916254c9c858175041c1211bfc16cd753e161d88290670f2cb2c7af50e6"
    sha256 cellar: :any,                 monterey:       "8e7759ebbd3a9f05d1cb54fde3297f696a80a968e982a9a56e9d8a6d6a2d1171"
    sha256 cellar: :any,                 big_sur:        "56fcc8f4e572f87b80fa64e6c740e6c546f31e97789296e00d7147a0f29ae923"
    sha256 cellar: :any,                 catalina:       "99e6f041fc94715f6c621d2f22e666c4d9f2e75e7fb641f402eb6ab4621a675c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13d94485675e688f1281d36e5c0fb5379218007d0c704115c7f1e81558113ab"
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

    man.install "src/etc/man/man1"
    bash_completion.install "src/etc/poac.bash" => "poac"
    zsh_completion.install_symlink bash_completion/"poac" => "_poac"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin/"poac", "create", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
