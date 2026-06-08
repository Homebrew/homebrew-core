class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "e71f3e0b6cdbe9948dcabd6e70a18a29285d8a6af3e54bf91192f1aea7099c7c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6db1aa3be0b7592f43ac6299f692eac25a4349547a9da09ada163f70077c1300"
    sha256 cellar: :any,                 arm64_sequoia: "9736ec159cdd66b33d628dd478c794aa71ca02dcbce4e60c3f8573cce5e0806c"
    sha256 cellar: :any,                 arm64_sonoma:  "de8a939e6538efb45e5faf5efaf9d19e941ab10ffa887b8359d8df4569d673d6"
    sha256 cellar: :any,                 sonoma:        "e3900581eb750c9477782a0fee98cc9d14494c0b2a1fe3993cc0c6882f2a8ec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d971b1fa0766e5a78a5195f97cb7817f27484f927947a4b35ebbde3ecf6800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e812626fe3aa2ee348f55d251c424a4761cf5fe275fa0e195cf3ff96830b4d6"
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
