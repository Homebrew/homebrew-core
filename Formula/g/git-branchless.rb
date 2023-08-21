class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "90a69356573acd0984607749cc18706c5a2410e1d59b553df5271ad3e4147dbf"
  # dual license change would be available in v0.8.0+
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6fd4b9846f02fe7d1265b5be403d9ec4df4d95708050c1ed1e830508efc0682"
    sha256 cellar: :any,                 arm64_monterey: "314446b64fa7ef9dac53476e526676b085b86c9604d3b5ffe9c9725604bdcac9"
    sha256 cellar: :any,                 arm64_big_sur:  "492a3d24fd20b44c74d5f15e4ac1a86e1dcb9ec844dca021e6b4f9402f9e746b"
    sha256 cellar: :any,                 ventura:        "0bb6125cb56124637cbea4a4a6799104059d9da9658cc471f87fdbd888003dad"
    sha256 cellar: :any,                 monterey:       "2194218f066fb8e2542427e4953a2a327703142b1d9d2ce0054e5f15070b0e72"
    sha256 cellar: :any,                 big_sur:        "e5355e840e2af38c1a8c7ab2c8a27513eed7213f22dcf5f5ab5486d4033b7d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199f61ade258d7a5a01a7726ea9ed51c8405c9c3322b042fdc450dc0e7c4f597"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man1
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
