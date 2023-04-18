class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "69639a25f9f5f38a3f4334f12f1bdb31d8055922b5ad8d5c46353c6d464d3ea1"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c340efd1a2557efe1d42770e0566f5ba5f2edaae137cb5a4693baecb826ecab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c340efd1a2557efe1d42770e0566f5ba5f2edaae137cb5a4693baecb826ecab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c340efd1a2557efe1d42770e0566f5ba5f2edaae137cb5a4693baecb826ecab"
    sha256 cellar: :any_skip_relocation, ventura:        "9040d5a420b8aabdf34117307369d84c98aa614f88ebdb846cc231910356bdfa"
    sha256 cellar: :any_skip_relocation, monterey:       "9040d5a420b8aabdf34117307369d84c98aa614f88ebdb846cc231910356bdfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9040d5a420b8aabdf34117307369d84c98aa614f88ebdb846cc231910356bdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f82c601d4dc585302fb7ca242802b79ee25d907868fd31456d285ef1537ac2c9"
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
