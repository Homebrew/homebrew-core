class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  stable do
    url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.8.0.tar.gz"
    sha256 "f9e13d9a3de960b32fb684a59492defd812bb0785df48facc964478f675f0355"

    # Backport support for libgit2 1.7
    patch do
      url "https://github.com/arxanas/git-branchless/commit/5b3d67b20e7fb910be46ea3ee9d0642d11932681.patch?full_index=1"
      sha256 "ff81ca9c921fc6b8254a75fecec3fc606f168215f66eb658803097b6bb2fcdb8"
    end
  end

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "723cd94950543af845b21543d1f0d2a99ae17fd6241add0403b1a7e0a8f0fbd4"
    sha256 cellar: :any,                 arm64_ventura:  "5550d80acfcb4818b8f5f92c95e64294d4a3b6b8bba34761e1854c71251cb957"
    sha256 cellar: :any,                 arm64_monterey: "01fe75552c47f9500cc47a9cfc5f16cae879b27ff77a864d6c50bb617e56851d"
    sha256 cellar: :any,                 sonoma:         "42aaf6d763b559bcf1a2ef8e083d01edfc25163857572441b9721cd1d2fd7c0c"
    sha256 cellar: :any,                 ventura:        "704d3ba94268d57a36c9c5e65a1dd72e4184a8c38e21138565eb082fa6b545de"
    sha256 cellar: :any,                 monterey:       "d19937979850141ad61000f9e71c4234316c9fb838f20ce5ff5710bfb7feb1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b8360a364a810027705d3adce5d06e2580e4ddc626a91460068c8a181c0681"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
