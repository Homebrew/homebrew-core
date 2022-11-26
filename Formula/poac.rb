class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  revision 4
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f4f4a4e5391711fa5ae47419fafd1c7c3d9d52108a6a84d7c6a2598bc12d5a9c"
    sha256 cellar: :any,                 arm64_monterey: "0e4a3817fbd3e97354dda7043f8e664125022e9d89fb29a3f96ed8351fb20596"
    sha256 cellar: :any,                 arm64_big_sur:  "bfe8ae0e153c4a3175a1123806858607c2efe5df0641b01aa9238faaf54cfe44"
    sha256 cellar: :any,                 monterey:       "932bef48de62ce5476c19922f058913e9504d3f940f14e318db11b380dad82f8"
    sha256 cellar: :any,                 big_sur:        "27fc0745d17099863c60acf92768d2cee215cf904e797a45d37fc69e8ce3a502"
    sha256 cellar: :any,                 catalina:       "5dfd726f44f674bb80b3319b01060ba66b7143e4a8ac051b0787b44b162fb9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c17cd835d36713d5b575cd5311ba55252b239925162143dad5578def6750ade"
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
