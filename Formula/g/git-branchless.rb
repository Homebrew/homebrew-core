class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  stable do
    url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "1eb8dbb85839c5b0d333e8c3f9011c3f725e0244bb92f4db918fce9d69851ff7"

    # patch to build with rust 1.89 and bump git2 to 0.20
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/git-branchless/0.10.0-build.patch"
      sha256 "7624b6fe14a4d471636e4b22433507b2454b7ee311eac13c4d128cb688be234c"
    end
  end

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f80d2b33570eb37e0d36b7e6d8008b867367c866a4811776040e494d7aafce7b"
    sha256 cellar: :any,                 arm64_sequoia: "c437b66e24387f64d6f01db4a5a9b10abb6c2f50eabc9676431c6155fbb115f0"
    sha256 cellar: :any,                 arm64_sonoma:  "82979920aabde9e15b626facd21ccace5d30c61a9f72a334567fbcbce5788cd8"
    sha256 cellar: :any,                 sonoma:        "14d54ce7c0637768fa4acb4adaa7c834fb48bcb53dc99a6008a9ebd799745f35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c168af51844af0bbc325a0d7f3d56952eb386084e2ded11c4b64354a656b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33664c6b9a58a86309ab4a9ec2799597a606d2592c9977e550e1057169f66cc"
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

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-branchless", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
