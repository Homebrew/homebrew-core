class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.6.1.tar.gz"
  sha256 "489b470ee4f3f196ceb3c466ee86469bb1c71849a1d886ae43451da872643bad"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78eb7f4d76bec02eaa45c9b981a9434d831120a91f4ad0a06e59ab7f7fa9160b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78eb7f4d76bec02eaa45c9b981a9434d831120a91f4ad0a06e59ab7f7fa9160b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78eb7f4d76bec02eaa45c9b981a9434d831120a91f4ad0a06e59ab7f7fa9160b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc6f2725a1f861964e58d868ce6b80b21d1829e972d2cb32938f80b0696d19e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061ab4fe7c7861a7bdaf99eeb5e8826fc77282ab678c3f18bd1be4839cbec9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d706a0b4cad5e8b996020ef02bf820b461e65190dca28be2d7388d6dd291e0"
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
