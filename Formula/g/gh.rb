class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.89.0.tar.gz"
  sha256 "bc9c11f75e4aeb7e1f0bd5f543a3edabb8958655025f8cdc3d9bbe14435a7441"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d38b4c92151619a22bbe519d6ee37e63d6e9ebc10159092e207b1fe2c5acd342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa5f8402592fabc9f8eb4178e5c861c2f8810a00082bc2cb0f965129376ffe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9440379ecca91536cf172e877fd3ea612d7ad352b6022434a79b3b3fd220d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3e174524b1516a9ef6ef476fa6815d611b80caec8c0d8f5ff61c2438d609321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e06003683b8fea47b5088494f97a1bd547129a26547112ea612b9c251f678a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d34f1d19d365cfe3b11ab92fbca00bd02a6c69b75d799b7569f4c37d59c29c7"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
