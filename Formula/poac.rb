class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.5.1.tar.gz"
  sha256 "439ce4f3be89e33abbafe5ef5bef53e2c6209c0cc0a8e718698675c247fb2ca4"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22ff6c3c8e3516e8fea9482aa3db8d2ea3c5068ec20cd029b9894fa8f069e06a"
    sha256 cellar: :any,                 arm64_monterey: "62eb08441a7e574ba07f6693fd9ce2ef246b7cc4502137cdf35bd26d60d84a8c"
    sha256 cellar: :any,                 arm64_big_sur:  "fb02b40300ae7f52e6dbe41ee68b915b4a211315b48401681700702050c1ff15"
    sha256 cellar: :any,                 ventura:        "9a7775d491ccb71c4e7396c9b04438adf474a61576909cce42ae740311e615c7"
    sha256 cellar: :any,                 monterey:       "6f1c53ec7c7bd21b2b774f869570a63fb5267259ff2008be863b72f391cf5d8f"
    sha256 cellar: :any,                 big_sur:        "195f49d03013e49265f199fe5b03f78c2836a01d11988f7c2fd983ca3234a4c1"
    sha256 cellar: :any,                 catalina:       "fac554b882507bb5dac69ba90eca3605eac91e143680130779ec61b28e362643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53ef4f70d181243cadbbe001c22b15b204dc6ec276c59d3e47234ef3e1c61bd"
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
