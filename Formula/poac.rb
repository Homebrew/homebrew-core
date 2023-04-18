class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.5.1.tar.gz"
  sha256 "439ce4f3be89e33abbafe5ef5bef53e2c6209c0cc0a8e718698675c247fb2ca4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d63abba6a9a99a27e6cc9d9143699dd4bc8f13aab8f2baf47c05dfe79ed678b"
    sha256 cellar: :any,                 arm64_monterey: "249261a831ae6f8892891282fee03b0b3482a931f3f956e4788b25c2ecb7d389"
    sha256 cellar: :any,                 arm64_big_sur:  "caf395cd6a2b2d3987c5b92346fcad60dc4b819782fb119ebbe0b456280923ee"
    sha256 cellar: :any,                 ventura:        "4f890dbda15ea80c6b89187aa249dc4d0739014d9037f4152b1bd4d391895418"
    sha256 cellar: :any,                 monterey:       "65526a5b66e26c8ae5593dd0b22afeb42865cd8bd32bf3eb7de8a2e94fa5d7b7"
    sha256 cellar: :any,                 big_sur:        "327487d16905a2f449532451acbebcd4830d89a73b6ce47cad972cea9197dace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc3bf8b380ad1df27e423b25c9815288c41098b66d37e268720445f5509c8a6"
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

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "5" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    system "cmake", "-B", "build", "-DPOAC_BUILD_TESTING=OFF", *std_cmake_args
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
