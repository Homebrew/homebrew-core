class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "13a7441be5c002b5a645dd9ad359dad5bdd46950b51b49e3cddccd9041deb5f5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "5f822cc3afeaf27cd30968034621f617fd344dfd0182842dea3332047ab03978"
    sha256 cellar: :any,                 arm64_monterey: "de47a87de4e8842e0a0be1a5bef9468647758c7f1036cb788136b80a028259b3"
    sha256 cellar: :any,                 arm64_big_sur:  "625dde30e9e5c934d8fb1b718621b340d5ee4aaba8a0ca5c3a2d72c302f96f76"
    sha256 cellar: :any,                 ventura:        "206fd72b6380c7f42ac7c95bf0c595e70a17fc470327e2e752325ccad497782e"
    sha256 cellar: :any,                 monterey:       "f4e4f757475e268d65f3c02ec8802a25d705c599972b6e6a6faf9410ebc794cc"
    sha256 cellar: :any,                 big_sur:        "da028eeb590115855e9679a71eae8b9db433b69e88e5e85c559fcb3fb28af07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94111a6eae62eae15f3d5a9999a430142394b3ecaf48f4189442e9506e91b9ec"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

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

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
