class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.10.1.tar.gz"
  sha256 "4be4f9d80ee1b4b2dd489bc335d59b50d945ad2bff9458eba66b230247f5c8a6"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a6a22dea81a6f82833163d1a7541f7b1856dbec8eca1bed9d5c0365e65e50076"
    sha256 cellar: :any,                 arm64_sonoma:   "ce280c229ec1bf6ca4f8d50a0337a7ef24f6c49447725a0237672a8e9657147c"
    sha256 cellar: :any,                 arm64_ventura:  "42bf04a9fb7254ad547e688696fbfeca929aa459a578875aafa71d8a9db01729"
    sha256 cellar: :any,                 arm64_monterey: "0c65b81b080635d90dfbcf52f436d16d01fc0fcbff37afc586b55f964f35dd9b"
    sha256 cellar: :any,                 sonoma:         "884538639f5ea51af10475448c7b6842b7b37ff62a52e4a12aec77c577f60d6a"
    sha256 cellar: :any,                 ventura:        "22d3259793bc6789619a425a12b9828dac69bb654c7fa03a3557b1102797869c"
    sha256 cellar: :any,                 monterey:       "042cf881a92dbcf0e89efa098fef63606efe337a5a6cfbf514e5d28cd414f72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1c2ab967603d03c320774091f89b110b5cec3e96526b56bbfa1316c9b55b77"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkg-config"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "11" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    # Avoid cloning `toml11` at build-time.
    (buildpath/"build-out/DEPS/toml11").install_symlink Formula["toml11"].opt_include
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin/"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/poac run").split("\n").last
    end
  end
end
