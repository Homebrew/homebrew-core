class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "b6a2c5b5d155d6e4a7b3786e235b9c444292e2f2efe2446e4e6905d7b6cf7ee3"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bd57d8e982a107111074fc18728d11aeff846a7f55282c5d0f21d69ec02254f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28cea503edee6cafe0da47c6e41d26e2987b40ee272f8f3f5237082b0a2a36a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "279b5c412a07cbf62f541ac6a0a3a4932fe43a75d5ad4c2e33e2d1c4ba5e5371"
    sha256 cellar: :any_skip_relocation, sonoma:         "9da482d7a8c4451c986258e5bf2ed3a4b760933db42a3c649c6087a5681f9a29"
    sha256 cellar: :any_skip_relocation, ventura:        "3bae653fb352c4be124051a87fbf12c470277cfc0882f1b80a208162efeb9def"
    sha256 cellar: :any_skip_relocation, monterey:       "56143cc690e4e0d101e9640174c4e4d26c7dfd364414014d878c80a74378a05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2bbd594a5a14607ec723f7926717dbad5294ca3095da2b300763d2ae210b57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
