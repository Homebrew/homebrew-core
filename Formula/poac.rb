class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.6.0.tar.gz"
  sha256 "40f55553f7cca3bdad39599ce8c9049aeecf8f6140cfebac28c51d7d9abbbb78"
  license "Apache-2.0"
  revision 1
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d2bd4df9517df982ebef65b067c5a960a78636a84daeaa7ccc3fd759cbaf0f5"
    sha256 cellar: :any,                 arm64_monterey: "c56f7321951827a413cf0b9f6766e061548c85151982c33e326e035c8f0284d4"
    sha256 cellar: :any,                 arm64_big_sur:  "fb3d115ba3762d2e95d970f8fbb6d5094d4ee0724f45b2030a45f88a6768df76"
    sha256 cellar: :any,                 ventura:        "e0c53dc913f3c6cccbbb26775c8f0c80cf0ec50ae4b07b66a82871d26562a73c"
    sha256 cellar: :any,                 monterey:       "a239df62224581ca511761de3cf3c749342a8db1c52146eea500bc6bc4daad5c"
    sha256 cellar: :any,                 big_sur:        "d0831700475599594650c2e396b85e2e7e276d8915b82fe767c669a8ca462cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807a84029fcc57eb7fe82ee23b841fc2fd56c1cfdfa7d539ec99d5c065b633f3"
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
