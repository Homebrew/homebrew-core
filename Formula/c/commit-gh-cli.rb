class CommitGhCli < Formula
  desc "Secure Git commits, releases, and repository security hardening"
  homepage "https://github.com/raymonepping/homebrew-commit-gh-cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.0.26.tar.gz"
  sha256 "1dcd65b37e01388d2621ff90b94b0e48649ae249ea2a2983cab6caa915be56a5"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "bin/commit_gh"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/commit_gh --version")
  end
end
