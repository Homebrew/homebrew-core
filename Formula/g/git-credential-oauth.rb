class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2acf2c1c9197e179e3068e318da67ec1af26feae63d8661c930963e3a7704ba2"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d62631e47c2f4fc6224e17edce6e55f905474052f4d3ef023662ca8abbf4cb00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d62631e47c2f4fc6224e17edce6e55f905474052f4d3ef023662ca8abbf4cb00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d62631e47c2f4fc6224e17edce6e55f905474052f4d3ef023662ca8abbf4cb00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c8d5262ee2a185c10cd56180f5168609670c7c2c973800fb88d50ec084590e8"
    sha256 cellar: :any,                 x86_64_linux:      "24b2471eb247afd061647d8f71136492b8dc8baf5c61a3d1f6fc021dd2ec8db2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
