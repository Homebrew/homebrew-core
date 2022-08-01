class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.10.tar.gz"
  sha256 "faadd38212638887effd129c282b3ca38e082c77a0a0845d9c11ca5600b44ba5"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "624235bc402344357a6bd82ea19516c7f9a3482aa9fd93d59b209f93cb70fa5f"
    sha256 cellar: :any,                 arm64_big_sur:  "d0c6378d8d978eadbac5de2f372f202448ae905c4b5b76fee408e8a3fb65bb96"
    sha256 cellar: :any,                 monterey:       "c517859d58d37c4575d43d317ca8ef31a0f32c7febec84c35bf4c59952c0b0eb"
    sha256 cellar: :any,                 big_sur:        "a4db0158be1620600148953dfd37c4216328a60f3b165489b56e2e79ff40ddb9"
    sha256 cellar: :any,                 catalina:       "6e4a8b15b9edb5091c4c41d22ec8c3231a59887ed32643825d25e6fd50d1ce7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de32506d803db57c0a7f77c6c6de881c1404a86f992c2b46d419f61e057dacc0"
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
