class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fa64dc92ec522520a6407ff61241fc1819a3093337b4e3d0f80248ae76938d43"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "31c9a297b2edcb5cf217248a6e4c48e36cb0899fd38ea12d17f224758bf81989"
    sha256 cellar: :any,                 arm64_sonoma:   "47147ac474e471683944e538c51247e38cdbf0807490538de8e29df3f7f6bbf3"
    sha256 cellar: :any,                 arm64_ventura:  "326b1e0ee09e7adcfc272ad867949d3a6a24887a4f1964c18d9515ea8426d067"
    sha256 cellar: :any,                 arm64_monterey: "c477b93819d928cf1f49809da31fa435f0200502ca72082a12b63a7e33cb8cd5"
    sha256 cellar: :any,                 sonoma:         "9d9b8cbdbb39e63c00d2422f04b61f7b96be8f1e5928a7a5431b26f64bddb8fa"
    sha256 cellar: :any,                 ventura:        "9284601e4244db3daa85285f70718265ff6eb3182d7e15fcdbb37efa20ba6b88"
    sha256 cellar: :any,                 monterey:       "8724ef70c232f56c1ac3d543acb54cf85b8a49f426b81bb8b530550ab3dede69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22cae8643755fa4b87dd7cafa858a5a456a85fb39569a55afa0125ef42083fb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
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

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
