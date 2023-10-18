class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "324dd0c7d2692c6bc61c8f054fe3870a45584720502f765e8faa88811b7167cc"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "312dc79d5e87a513e19ae4eb0021e4e489662fd7e3cc8720e58e6ac1e22f0823"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1933c80ac6ac7257628cfbb30bed000bb07fc559de8a5b0d3119b240c6b7e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e62d9c0429e18441905d1c0d49c62e6c96c64f894601ea2429da3707f4efd896"
    sha256 cellar: :any_skip_relocation, sonoma:         "5898225216e2cc183e2b419919f4454d9f294a070b7d6feee2c1555f5deecdb5"
    sha256 cellar: :any_skip_relocation, ventura:        "711e5d0da5aadf6562b1a4c9d9005201a92f909b407c52d246b7deb67eb2d325"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc18bdfaab89a5fbc37320573392f5a9fd5dc3d9e2d2e466709d1a1d9d51e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16fcbf9d42394829d2962f4e61fb60aad8478fdc9a6bc9e1ea6897a2ab0b7012"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
