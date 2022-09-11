class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3717a873120a7125fcdcc99227f5c7d42c4e170f7572feee19ab458d657f9451"
  license "Apache-2.0"
  revision 3
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "172b32c97477417429b1bbb52f26982702bd8f9b4e170a64557302d365927b94"
    sha256 cellar: :any,                 arm64_big_sur:  "ac048ae45cf0aaa3dc2d62cbbdaa157510184fb2001440f95f924f6ba58fd45b"
    sha256 cellar: :any,                 monterey:       "836ff1bb37c3b927e99c5e50f22333e1c166e150aba7843d38751746b1bfcec7"
    sha256 cellar: :any,                 big_sur:        "478f8405d11592d81e6dac54e465bcebadd9f4a6cec94396917ae9303d536436"
    sha256 cellar: :any,                 catalina:       "33c8cd587f69f1fa577aafc10fc7bb537eca3c7728e1659fe26a553de2d34687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1636e55ef9142ed54a1bee793b8ab814b16f992d5ddeb0bc0a7779d45cdc0dbf"
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
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
