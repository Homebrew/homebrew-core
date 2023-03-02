class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "13a7441be5c002b5a645dd9ad359dad5bdd46950b51b49e3cddccd9041deb5f5"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7097d5226186a40a5577069913b66cb6f50697c18ed2a9382500346c32269e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a2e9068007931a64ce9ffd8d4ebe4a6abd919fa8d00d17212d2092c1541413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8d5c87a1b6b7900655e171bae899374a165e33ab22d565ecd867e9932d9c93e"
    sha256 cellar: :any_skip_relocation, ventura:        "58eecb4f015b929b1fc18c4c636f9beca3f0926998699c1de96932dc5b14fcdc"
    sha256 cellar: :any_skip_relocation, monterey:       "35941715dcaa62518162792c282485985ce4b65cb41f82282540033f439072a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "373c63d6cacfdb277324d29ecd7715846577aa7eba991ce327a262227ca129d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf7f015971734d8f7dd9b5a2decda30a504dc7af449fda1cb85d8815f91e063"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
