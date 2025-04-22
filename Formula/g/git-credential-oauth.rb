class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "c9b067fde5849b597aceba15b76c5b9ccacee4e5736e88c9ae430553bb7f2898"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b613c68a1fa516f514863a65d773234f3171dddb631a929b52436dd2a15ae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b613c68a1fa516f514863a65d773234f3171dddb631a929b52436dd2a15ae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92b613c68a1fa516f514863a65d773234f3171dddb631a929b52436dd2a15ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "458e6e4882554340e19783fe94977f9bcad2b72aedb7cf0a8247b11226d44cbe"
    sha256 cellar: :any_skip_relocation, ventura:       "458e6e4882554340e19783fe94977f9bcad2b72aedb7cf0a8247b11226d44cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0fc4b2072645c4b158dc583b8f1af9580d678c87678547ef7e6088a69be812"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
