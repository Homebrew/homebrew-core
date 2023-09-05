class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.6.0.tar.gz"
  sha256 "40f55553f7cca3bdad39599ce8c9049aeecf8f6140cfebac28c51d7d9abbbb78"
  license "Apache-2.0"
  revision 4
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7264c6ec7cde08cab75221bda05747b0158e8bd84194dd99bc8002ae0e22a7f"
    sha256 cellar: :any,                 arm64_monterey: "7a4308dae0c519cca092333b242a284c3e0f12f50957f999ccb2f0064996aae9"
    sha256 cellar: :any,                 arm64_big_sur:  "f18740594d83e20f9738846fcaf2f9681f6ac33ff559e95aa8c4cb3f7e70047a"
    sha256 cellar: :any,                 ventura:        "b1cda02d8561d37821cb1a78c9e69d17e9efa283e046f4f713a8be1baf01bf77"
    sha256 cellar: :any,                 monterey:       "036be47724682d90f5d7baf82fdb2e5e6c637128c2995d7584d2c0b5bc7f683c"
    sha256 cellar: :any,                 big_sur:        "aad661ddcf4a5754a5c93ca6d2daf2e794a715a09a2f7cfa107d3ddefd79f4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5861b764ec78792acd2aa3853b275b1eec71279d09cd659fa9432e9271d69d2a"
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

    # Help to find OpenSSL.
    inreplace "cmake/AddOpenSSL.cmake", "${POAC_HOMEBREW_ROOT_PATH}/openssl",
                                        Formula["openssl@3"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-DPOAC_BUILD_TESTING=OFF", *std_cmake_args
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
