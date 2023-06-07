class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3c48505c9fc02ef46a5ecadcbc4470a5389d82c7e607448d2d24333726c08809"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50ff0c98fcbba988b6c9b82b4bc43ebc3d2244d707d7e2ea9bd82fd3f18a5b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50ff0c98fcbba988b6c9b82b4bc43ebc3d2244d707d7e2ea9bd82fd3f18a5b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50ff0c98fcbba988b6c9b82b4bc43ebc3d2244d707d7e2ea9bd82fd3f18a5b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b52c205cb583f3fe5ef46985c3af23202dfc0336a2e61e90c717625b91c505"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b52c205cb583f3fe5ef46985c3af23202dfc0336a2e61e90c717625b91c505"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b52c205cb583f3fe5ef46985c3af23202dfc0336a2e61e90c717625b91c505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3b5f18f8b3cd3cc29cf955c4d1f23d11dee2599b718e1c7af72c892730ab9e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
