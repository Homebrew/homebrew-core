class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.6.0.tar.gz"
  sha256 "ed99d43110ee3cc609906fc2b29d222dbea18d1e65c5bbacf674e8e8f07acf4d"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9749939b74685de360400e9615dd6ef0242904683168aba5a381ae3df7b92a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9749939b74685de360400e9615dd6ef0242904683168aba5a381ae3df7b92a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9749939b74685de360400e9615dd6ef0242904683168aba5a381ae3df7b92a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf1604e629f247e683570c21b026cbf7f6c624bcbf96132eb09f795a6264aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9590dc845b39b05c217d6e929e2872cd68cf5e90e46bf350b5148783e29b717e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2297d4f062ca6b6c7490aecdef76f20e657a3cbc1d40d7f118259bf87065e781"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionOverride=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
