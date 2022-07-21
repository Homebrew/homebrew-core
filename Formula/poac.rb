class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.10.tar.gz"
  sha256 "faadd38212638887effd129c282b3ca38e082c77a0a0845d9c11ca5600b44ba5"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "934119c7c84a0070dbdfb1d570f57e7bfd41734d40e04d56a24f714253d2dd59"
    sha256 cellar: :any,                 arm64_big_sur:  "7b59a1d63125e64a5184af52aa8d9668f67207980e4451221e8a42d5832e7f42"
    sha256 cellar: :any,                 monterey:       "ba9b8e2bfc4d957911d040538a68ba769fdd3a0b8a34071cb1157eff87c70f4c"
    sha256 cellar: :any,                 big_sur:        "bfa3a9fb1d09835867fcd059f9ebc2863fcde1341f1aa3a5902659cc2fb70c7a"
    sha256 cellar: :any,                 catalina:       "3333491952361656d90b59e8a5891fcb403b85847e16135dfdae2c50d49b3357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c8e01f834ae4ad2c9c454e652a18a784197a44f1dd172090685d919b435666"
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
