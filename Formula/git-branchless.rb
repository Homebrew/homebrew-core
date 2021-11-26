class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "d23341766c0f81fc5e0768a399139738d472bcdd315c62b2b5ac9ac857d0d501"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

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
