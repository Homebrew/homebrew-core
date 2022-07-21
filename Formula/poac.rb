class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.10.tar.gz"
  sha256 "faadd38212638887effd129c282b3ca38e082c77a0a0845d9c11ca5600b44ba5"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f378b6863622714af5d7dcf29902138a276f9da649f0be35988e795dceb1ee31"
    sha256 cellar: :any,                 arm64_big_sur:  "fa0f16bdeb5d33275566ba5acc5110b85f4bddbc7a6abf886414532d1aaaf2ac"
    sha256 cellar: :any,                 monterey:       "ad625953f13a3ada444bc69b8dffa12d7a2a0adb527b9887d2ddd45a79c9a12a"
    sha256 cellar: :any,                 big_sur:        "1a0542b0bd7357545be405910f76d54d8a8e2b31b56db1fffb7a98ba04db47e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f990ece176643b14232d6236581e5e15c657cf24d66875347ac108f98cdcaf1f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on macos: :big_sur # C++20
  depends_on "openssl@1.1"
  depends_on "spdlog"

  uses_from_macos "libarchive"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5" # C++20

  def install
    system "cmake", "-B", "build", "-DCPM_USE_LOCAL_PACKAGES=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man1.install (buildpath/"src/etc/man/man1").children
    bash_completion.install_symlink "src/etc/poac.bash" => "poac"
    zsh_completion.install_symlink "src/etc/poac.bash" => "_poac"
  end

  test do
    system bin/"poac", "create", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
