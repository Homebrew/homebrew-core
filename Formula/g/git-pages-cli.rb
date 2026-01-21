class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.5.2.tar.gz"
  sha256 "1e60a9b03a99558dca18b6891c2028386450ec6f688d7315c6a5ce91562a32ea"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfeef6686b9ff0a6bc79be6c0feedbfc8a32bd3b04cd8604e80652aae3f37328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfeef6686b9ff0a6bc79be6c0feedbfc8a32bd3b04cd8604e80652aae3f37328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfeef6686b9ff0a6bc79be6c0feedbfc8a32bd3b04cd8604e80652aae3f37328"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec5eb9425d07b01fe5eb95fe0ab26266488acd6da358d60f8b096bfdb95615d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d0fbabce7b4ac8ed7718b536b3fb445c09a9e8cd02b366a5312fc6527a1c353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5526fa7a711fd499ce90a5c3629a7a8c462256eecc3888cf7e1f4c2074c10c"
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
