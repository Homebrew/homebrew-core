class GitCredentialAzure < Formula
  desc "Git credential helper that authenticates to Azure Repos (dev.azure.com)"
  homepage "https://github.com/hickford/git-credential-azure"
  url "https://github.com/hickford/git-credential-azure/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f3a05c73d03b0e5e58a9cd88275422a6b4b5e2ef75fd193b0f1c972e663c96a1"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-azure.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-azure", 2)
  end
end
