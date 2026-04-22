class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.91.0.tar.gz"
  sha256 "6409f89e1b8a69347fbdfea4b60cb78d4c58217c3d96c858ce0eb8b0ae853b59"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d96f909587d6c0799b5c29604e89a22762adc5a26a41808e983a604996fb98a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224ab1e0deaafc0d031aa220de60ad7376794efde3680e11322e845f072783b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d60565612a7186737272129c0f20e3b505ca22c9253dff5e2681057cfad295d"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d1350e9ab58ed5eaddd2b626716567f4a7d17e8857ef194c95220f228cfbfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902f1e9c31abfe6c25b1e14a6903071dfdd16591eac2aa3d6ddb0b2dc3feda0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ca3b0d9eac2eda76fe589a66e9b1099cb4dcfd6fc1abf97e9428361eafee23"
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
