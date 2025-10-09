class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2ee9075688e3c23f92ee74e7d1e7579346e76811d5729495d3ffda053057f4b9"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24ea8af684332afb407196d13f81a9b612f9b72eff1b5ee23339bb2c0bd1948e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ea8af684332afb407196d13f81a9b612f9b72eff1b5ee23339bb2c0bd1948e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ea8af684332afb407196d13f81a9b612f9b72eff1b5ee23339bb2c0bd1948e"
    sha256 cellar: :any_skip_relocation, sonoma:        "40639e93a82f843be26bf8c1f90754e5a5a24d669f58c6bdbcfbc867381b80e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7715f005b2445ae554fbdc5886303a159ac4d0a3f48f25549832013dcf679ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cac6bda79920bea6a21b2ae36e054abb6f65da276be5c82d7482e01e3f9caba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
