class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "fe54bc6053c7696d2ce990698cf469e2463266a71dab6615ab6b557c9eecc5e7"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "588c6f5e7c80822c228a3a61fc9d7d325b82b76c81c52300416ea645c06520c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64f792a5e52bcca31c076d7d9b2164d13f3b5e1d8427a18fdb3c7239a2571fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3d80bd74733d845f250560a142ded6474b9011d86f4b7ca1ac9bbea0dc5616"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd84288ef10fd4295ae4c670955e0f4940415276d62421bc2c6c450f35131da8"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc624b0201e39b9df85122973496e3005352e8c9a3308d9c842f788d35141a7"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba3a931ee56b9d119edb1f53368b932b7afcbe4641b7f8fd4f2fe760c0c4033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a97fdcca6f85bb4391db0a2faff22e65b7e32dc793e4ec7cde6231a023b92bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
