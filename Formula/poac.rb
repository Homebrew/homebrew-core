class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  revision 1
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1e435fa85041a1d49ecaf7f4bb08311b3029bf77dd9ae6a3e5f703d9d4c78a0"
    sha256 cellar: :any,                 arm64_big_sur:  "158ea3d2209f006a4c03023b0c8eb043a584e93a1c6937a1e2cabf74142f5c61"
    sha256 cellar: :any,                 monterey:       "50c6ff526cf6e7349ca48e78c4b4329bae928d30f5ea083beeb4b9d31878f953"
    sha256 cellar: :any,                 big_sur:        "2edd13afa73814fddc411e1ac0d43cb9dc05822c120348df97d250f69d0dae93"
    sha256 cellar: :any,                 catalina:       "c298a8f708f054c68ff60a7b569d36c1ab22576abe831aa1488e1c19d188b262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a459369bd757e66b7b7e696cd886021d8648b8384dd785da168c33c041173aef"
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
