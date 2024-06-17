class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "22afa94526b7da02c520fda36a531616e8f53bc6c34c1438e929337c990c65fc"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5e83f0a8a249a4a2c5b04be5b2c932163289ad7019776f7d7a3f7e79042e218"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6ebf1cd61e08e05b6239409366e8e6dc9e96f39c9e2e8e48e52edf302c1cdc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca1e8300354d4b9001d9fa53bca3d1a81041d94c01c4ccbc2d2b3c0e13962140"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf02cea4569edb62cd8958bd2b537ee2ce93f3862b5a774fe172dbfeb433b2e1"
    sha256 cellar: :any_skip_relocation, ventura:        "48fdfa6658292673c8bb7e530942e4c2e667f58c805636ac9eed2a94cc25d3d7"
    sha256 cellar: :any_skip_relocation, monterey:       "934ef0bfddc0f845eee4e2dc65bdc291d5c7f317697a00c9b3e1404c4b21ad09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f154bc06d458889d202c5615fa9b125abb96558660ca5cb1a7b57a5ab9745a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
