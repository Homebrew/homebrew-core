class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.5.1.tar.gz"
  sha256 "439ce4f3be89e33abbafe5ef5bef53e2c6209c0cc0a8e718698675c247fb2ca4"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adee712ee6e9d1b2c3790e40b5dba26c5e9e4919fcb91af302194d7f08ee3f2f"
    sha256 cellar: :any,                 arm64_monterey: "fb3d23a9b79b994bb5c7757eb30a759cad75f722988431fad9d16611f75fc809"
    sha256 cellar: :any,                 arm64_big_sur:  "f783e3f2f86151c1d73b15fa1904a552968344cd103903f52ac1e7edfadaa009"
    sha256 cellar: :any,                 ventura:        "5cbd4dbe598ddff26f4c61bb2c8af6c662cf096346ea7e835133bcf79ff6f43d"
    sha256 cellar: :any,                 monterey:       "764182fc107dc0a0cb8f7be3f69d045b6b81939584bdfa44660ab3269178f8be"
    sha256 cellar: :any,                 big_sur:        "a4613be522f0201662f4684e2e3d8174622be2bf5cdde438b600136b902fa36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66ce3c40e223be249fdecaefd7480b8f648a7052c60bfa734c92b05f1d1e8369"
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
