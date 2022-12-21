class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "a91d14b66be48f6e83803fa266a0cde783791d8a6ab5ab56040262ebc126923a"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa07601d7c892e804df769c28003e81a6d118d431710da93f22b0910b583985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0214ede8c9346cba15d8aa45147e130c6646d44182eac41bcc3a26e285abb43d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0786caf5c2af421ab38f4fba681ece7bb2e1eec84c92fb3b7e2c3890d2e8fa99"
    sha256 cellar: :any_skip_relocation, ventura:        "8a5b1632af54e0e78d291a82100c2d598fd83e4d830a7124386c243ada83ec65"
    sha256 cellar: :any_skip_relocation, monterey:       "4c0f24b7495f4ca3d1e9186da1b7a5d89def5f8958643b5e1587f195eeb8ec04"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6fab6ed9e7b857c939517eb9c2b259b5923b0a14fabd67220bf9cc1aad5cfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c13f7fc51d1f74028691c9d1f5818ce8ae8ec993496266bfe55e1cbbde7b5bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Authorization completed",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
