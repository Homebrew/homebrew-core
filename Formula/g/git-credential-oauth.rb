class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "0a0aea60bfeb19c9fa9d8bc2428c71a8b08c2b20b939a16b0709baf24d2ec7fa"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a29ec6e73aac63a5438c5f5aadfdb76f5255995b9f7074592033645bc286df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a29ec6e73aac63a5438c5f5aadfdb76f5255995b9f7074592033645bc286df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80a29ec6e73aac63a5438c5f5aadfdb76f5255995b9f7074592033645bc286df"
    sha256 cellar: :any_skip_relocation, sonoma:        "198d17566ed638fcc048dc8192d9d6207d870c113695f9f55b6a1bfba5e807b8"
    sha256 cellar: :any_skip_relocation, ventura:       "198d17566ed638fcc048dc8192d9d6207d870c113695f9f55b6a1bfba5e807b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b64f14ad4f84b3c3d6c876a61b6e81197824c76d27c8764229b92032be20ea09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
