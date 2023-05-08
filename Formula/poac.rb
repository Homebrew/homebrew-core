class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.6.0.tar.gz"
  sha256 "40f55553f7cca3bdad39599ce8c9049aeecf8f6140cfebac28c51d7d9abbbb78"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc5422c06923b50a42e1eca8fc8f20bd37647387353372eff1b14839ab30aa92"
    sha256 cellar: :any,                 arm64_monterey: "6f7c5bce5c3c51b0ad95c6e7d8cc2f4aabef63ba81426f5b58edcb06c3eb1028"
    sha256 cellar: :any,                 arm64_big_sur:  "6c1e8f8cace9630e557ff342bc2a871e95b320b3d0a8ea40d7251f19a6a6d940"
    sha256 cellar: :any,                 ventura:        "9758130ced37e0367b26b99350848b8b73d44cf6647bf87130c7b69b53133b09"
    sha256 cellar: :any,                 monterey:       "dddb54db771ea64d6bb0c0842788bab5c5c9c63b52c2116c60c6e73cf089b634"
    sha256 cellar: :any,                 big_sur:        "5187305ade9bd3dfc7ccfb92bfd9a0045aba9a029e5f62536b3e557ea1a01cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59336f07faf85623a5ad69a70056e2ceeee5dd4ee0838229c8592b75407feda4"
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
