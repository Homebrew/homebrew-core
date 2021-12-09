class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9046d5b93c8bc959b7d8ab5238d3656c7e5463e2b68951300a1feb86aa533276"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae4c5411e40a717d845bbc44fb21c4878cad26a366bf596b59940d10464cbc03"
    sha256 cellar: :any,                 arm64_big_sur:  "c51f1f14c0af8a45b17a310bdfa6f7ea83aac123550bd78219275612ded69a38"
    sha256 cellar: :any,                 monterey:       "cfe2387df1bc3690ccd528cab11163f4bfa93923fadb33fb60293ba656557232"
    sha256 cellar: :any,                 big_sur:        "b6b3bd8eba0c7e4d245ed98ece5b42a0a600214486183c23cf7eaf324febe626"
    sha256 cellar: :any,                 catalina:       "dc385af481b405f0bc9f07530d5a2131032a2f0735dc5ffc609d7388073343c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a82846c6858c32e810a1307ca647bb01525222b2d33fdf1791ce803266b58ac"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip
  end
end
