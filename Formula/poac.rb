class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  revision 3
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f0db4443983c815b98429e668f8d7d0fdf143876eb57e9a16bc769cb7b3f797"
    sha256 cellar: :any,                 arm64_big_sur:  "b6c74adbd8a5dd5773f46aeda390db16f48e3a48112dad1af5707809ece6f556"
    sha256 cellar: :any,                 monterey:       "88d05562ee26ed90a2958b2f957d83661c8231e05019469001d958ba79032c7e"
    sha256 cellar: :any,                 big_sur:        "c4b414c7a0634f2e5cd605c154d714e1a70a63b34dcf7f1de1ae86b816e188af"
    sha256 cellar: :any,                 catalina:       "4a3d7a94885150f390acac3f709fadf55a9996e44554cc10f0d9f6f253abad6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77c222c0d87bf25bdc18930b7a4ebb01d718eab06f2a1047bef7a11f85c3bb0"
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
