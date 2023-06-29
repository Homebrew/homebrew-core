class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.6.0.tar.gz"
  sha256 "40f55553f7cca3bdad39599ce8c9049aeecf8f6140cfebac28c51d7d9abbbb78"
  license "Apache-2.0"
  revision 2
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8abf849fc0be2706971419c582d1f6fe2ab17ec706cc672a1ec2d587b89e7452"
    sha256 cellar: :any,                 arm64_monterey: "9ca391a863ec65ff50d06cce7f82f884ffc8626a5e85584628800a79ca5f484a"
    sha256 cellar: :any,                 arm64_big_sur:  "3954502fecf09e7778d64c662422fadc2460d7b3e0d11e24b05467325a02c8a9"
    sha256 cellar: :any,                 ventura:        "44ed05fd38b73073e30f90a48f8ff39e107075f1b9d76e17ac1cc3adc326033e"
    sha256 cellar: :any,                 monterey:       "b9cdc6b2fe6fee492cefc64e1ceef84219674bd65ae7298c2fe618da4d21f713"
    sha256 cellar: :any,                 big_sur:        "3ccc08272b158ef81194795ebd7dccdbc734b3bc07f6de4ec9bf9f1ff54fe4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8177b5fd13dcec22369931eb0256a1a35f7932a15fa66dfcde2fa9e82cbe4d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "openssl@3"
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
