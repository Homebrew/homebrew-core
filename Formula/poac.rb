class Poac < Formula
  desc "Package manager for C++"
  homepage "https://github.com/poacpm/poac"
  url "https://github.com/poacpm/poac/archive/refs/tags/0.3.9.tar.gz"
  sha256 "da7d32a9898df4c2105cf2a4aa4bbd959bb28745a1d71a0069ef3985016819e5"
  license "Apache-2.0"
  head "https://github.com/poacpm/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57c7b5b1f9eb1308a8c797827717a9902a380946b9cb33c5cf94a8dd3d3ef7b8"
    sha256 cellar: :any,                 arm64_big_sur:  "9ca9780556ec7d273c78b427cb62e90fab4dd770e1adc46de8238c56e8dc7f7f"
    sha256 cellar: :any,                 monterey:       "a71b2fde9ebdf4f80bcbdcd1e69e8a453279e99a6246acfc8cc261e784bee350"
    sha256 cellar: :any,                 big_sur:        "3ab5cf475e0441416710421ba5eebf8d5acc016c469fe02bd88ef94e66462e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cbc629edbb3d47c1979e5e8dbe06d2e222ff65b5995681049ba8af2154aae3"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on macos: :big_sur # C++20
  depends_on "openssl@1.1"
  depends_on "spdlog"

  uses_from_macos "libarchive"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5" # C++20

  def install
    system "cmake", "-B", "build", "-DCPM_USE_LOCAL_PACKAGES=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man1.install (buildpath/"src/etc/man/man1").children
    bash_completion.install_symlink "src/etc/poac.bash" => "poac"
    zsh_completion.install_symlink "src/etc/poac.bash" => "_poac"
  end

  test do
    system bin/"poac", "create", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
