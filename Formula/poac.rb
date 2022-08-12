class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d402633bb96fcdfda943ce6d8bf5d445cf07d5e121eedf280b5f493873e6ea6a"
    sha256 cellar: :any,                 arm64_big_sur:  "7581dfd87e5584099d97477dfa91c12fbf04ac6122acaeab0c7600928ea9dee3"
    sha256 cellar: :any,                 monterey:       "40fb65339978b091b32224e591bd7d25d59dbc895622c1b9d61d73ab1b535ccc"
    sha256 cellar: :any,                 big_sur:        "699e0f0349c21fc5bf77a570ee321b3a3b0fb2a9006c1cfc290e5a34a4c409d5"
    sha256 cellar: :any,                 catalina:       "57de9408a30c7f5d7e23dfa931695e2f4f1a42f369acd9b5336b2e1e788e6291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d0f3d7f3607072c06b33e428133de7bbed523999f0ff6d7d9a74fef5870382"
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
