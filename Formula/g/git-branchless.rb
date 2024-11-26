class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1eb8dbb85839c5b0d333e8c3f9011c3f725e0244bb92f4db918fce9d69851ff7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42a77ecf8c5aea5d410cf2a76a0fc06f15e5674aeb88d17076e94a2c67bd4bfa"
    sha256 cellar: :any,                 arm64_sonoma:  "24000865ca925f6b59e5f3cf45ccbc34d3ad9d5059777e414e961b0a33e931bc"
    sha256 cellar: :any,                 arm64_ventura: "9eb5335a4ef1611c6355d4c6a5977e509e8bb0d40c346ef88b30502a99f24a1a"
    sha256 cellar: :any,                 sonoma:        "6553ee06179218268112ef31322133e69c392df2259244049b0abcd4f27101f0"
    sha256 cellar: :any,                 ventura:       "2a1ee3f6ffdf8d11c60ae9c752789f241c519b0308025edabc1ea07857c1387b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d92a10006422d6f296aef114de2a5f52b6537b117666ebbbc0b2bceb1e67bde"
  end

  depends_on "pkgconf" => :build
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
