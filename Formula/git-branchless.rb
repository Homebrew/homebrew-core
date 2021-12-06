class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9046d5b93c8bc959b7d8ab5238d3656c7e5463e2b68951300a1feb86aa533276"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f02ca20ad8e2ae17f3c9d70a97ab93512b7c456d3c3a731d800001513205600b"
    sha256 cellar: :any,                 arm64_big_sur:  "29f7389c6a175326fc9edb033c688e9bda35d3936311bee5524923522d544d46"
    sha256 cellar: :any,                 monterey:       "27d7843209fa4a91ba769190879239d47019f70099ef409e30ab536e0402b560"
    sha256 cellar: :any,                 big_sur:        "69d0dfd0467f1764c402b20f75bdf86f2cd328b3a82370078e7ff34c674dc5cc"
    sha256 cellar: :any,                 catalina:       "a88c1c8649d4010106050bf21d8824ff26343cc4eae87905218b41a1b5052be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4427f6afba2a7fb7b220545829e95973f7e969dd9d2d5d0cca39fead8250f19a"
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
