class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.20.0.tar.gz"
  sha256 "d8c16de9dc4ed5b42c84eca1be51f2bd84cb181b6f0cb932b6af4d8b2de8342d"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5757f6e0f6a9dab4ef58e397885cde6cf5a05e0b85fa7ac0733575f12f60c5ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9878b0274d38941a5c03a6f833462ac7dd7ee3b47f9bc4869848baab3848b6af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ce7dfc25cce89c5803c7e66a13b2823f2d189b417602b31373551fd37a41d9d"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f63325dbbfc3b3142a19cd22cb84275508fb3e2ef37267d64eca8a3b8a6f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "fceec8f15ff06dcc27ac51d06d4ecd97c8b4802c5a5a4e2349a6360f5624cabc"
    sha256 cellar: :any_skip_relocation, catalina:       "6440ea47fad7736297eb46167bda2292a17bee138470274eea76d57a01f8595a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f4b9e3f62b672e83a8650a068d777caf38be277f31ca994121c9efb8d237b5"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
