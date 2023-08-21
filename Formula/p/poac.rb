class Poac < Formula
  desc "Package Manager for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.6.0.tar.gz"
  sha256 "40f55553f7cca3bdad39599ce8c9049aeecf8f6140cfebac28c51d7d9abbbb78"
  license "Apache-2.0"
  revision 3
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2d1bbd692d862ed69a18aea000a2f3c3f9cb242a477c63536c21db759cb1a04"
    sha256 cellar: :any,                 arm64_monterey: "75266575278a200e0cdbb398b71ae0af259e6d707ed82f7d267285e206462b45"
    sha256 cellar: :any,                 arm64_big_sur:  "70968a60b071fb721aa96c9ca6574c65084ffd8d1114da4d1bde0be6972b0ba0"
    sha256 cellar: :any,                 ventura:        "f006371b2f7fbd03ab4d33035a7dad2f201242e4cd694103866669e5ce6626b3"
    sha256 cellar: :any,                 monterey:       "b86f19b504b00fad55955e52a67d69c5a035a3d7773f445480e7a3423c943380"
    sha256 cellar: :any,                 big_sur:        "f4ce26e6cd14546d3d7df1ff451d80cd84aa14644ef50c35f76dccccd9c48f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c78e46360c37b849eddaf9ca395c6384c178e70d9a26b568a7d0b7521066771"
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
