class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1a7ce9f8034b1372d97edf9ad3de81d46ae75ff43b2df11900ad140f5b53a2c5"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f649e311a98cd075ad03b44b5e73cbd5b5dcc8fcbad0b1078fbda82314833a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49d2dcd8a4dc826d4e540b1808c79b2b9c55a75b8fb429f24fa4292931f5736"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cd42d896e207718eb25b506215f79599bee9d6821cc00f6ad36f39af036d69"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d07fd7dc467642015b81bb5de1b014eee59720714f5a7f186c3e16b59396a2a"
    sha256 cellar: :any_skip_relocation, catalina:       "b336c0c7a94a5b19060134978cb20f724c3b2f408e1365b3584bc74fa4a9aa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90a497b062a5e47126c63407182697241136b617bbd3a3f073720bf8d40dd73"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git-branchless")
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
