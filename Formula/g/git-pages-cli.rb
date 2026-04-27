class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.8.2.tar.gz"
  sha256 "8e210c40c30de2100f6a9ea5b1c32ee83510782b7c2e68ae018d63a43744303c"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c78c363abc446d6efe77abbfc0236d13db749230acfc945e31a66c3a4bf592a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78c363abc446d6efe77abbfc0236d13db749230acfc945e31a66c3a4bf592a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78c363abc446d6efe77abbfc0236d13db749230acfc945e31a66c3a4bf592a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "769011c9668991a7ebe3d557c6b14450405f03850db7b5fd06e3fc9d7baadc2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc37f0000ccf5a61f23f5540275967adf717fe41fdcc7cc99b120c0e30c4323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76ef0dc6982b3c12c8700315ac2f14e1e06f55bb548b5beecd1337ae775fd46"
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
