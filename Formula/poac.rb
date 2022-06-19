class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.7.tar.gz"
  sha256 "2ad6c082252d15cc8e9db8d129e7dd9cb27275f0d72de33c73ada5c09667a87f"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba0a4ef79bfd3b0949c3f00811d55203484351642b1593a547a325963294fdf4"
    sha256 cellar: :any,                 arm64_big_sur:  "57a61b9ea9e166d06312941056f912f29fe616a50a3da18b71bf771155bed8cf"
    sha256 cellar: :any,                 monterey:       "8e61e3a2e92f2a685b0361f10400b17e10283cfd70fab3c2751c6ff85df56715"
    sha256 cellar: :any,                 big_sur:        "970c0f8398c48fe1d340037f10037d299c758594cadf20a239ce3afbe3e19cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a2ab431efbbac134a4e90c5aa394d84f96771c8dd6bf11701b55c41f2f1a6c"
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
