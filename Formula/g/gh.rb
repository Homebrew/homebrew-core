class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.85.0.tar.gz"
  sha256 "5fa457376a343b022dd8e881228c7b33290940f6289a7f3342dff0c914980461"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da71661c74cc0cfa841a0ba0e4406cceb246340ee217e2834e368447b209fa83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da71661c74cc0cfa841a0ba0e4406cceb246340ee217e2834e368447b209fa83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da71661c74cc0cfa841a0ba0e4406cceb246340ee217e2834e368447b209fa83"
    sha256 cellar: :any_skip_relocation, sonoma:        "168ae3758c965860fb3eebdb1e15b0de7d9939bacbd48adb0fb6ba4d57d411d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae3b0684dfc29e8afd48dad65978a72a8dc61c9f81190f6b4a8ba50c235a4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10674e9984e45af391f23a56daa405a460d8b6603fde600fb05092e70fb9809"
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
