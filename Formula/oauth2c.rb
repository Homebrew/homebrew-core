class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "83b1952ad9d4edfb4762a7dc1d64d2a34880da39f28ffdac65c3e113344a060d"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b154ab6337dd98cee004b62a84742baca1448bafe2c75edd8242949889b096c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b154ab6337dd98cee004b62a84742baca1448bafe2c75edd8242949889b096c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b154ab6337dd98cee004b62a84742baca1448bafe2c75edd8242949889b096c0"
    sha256 cellar: :any_skip_relocation, ventura:        "befed2fa492166458e1d310e4fbd503abfc11dbed31a5ea8be17008cc25dbde8"
    sha256 cellar: :any_skip_relocation, monterey:       "befed2fa492166458e1d310e4fbd503abfc11dbed31a5ea8be17008cc25dbde8"
    sha256 cellar: :any_skip_relocation, big_sur:        "befed2fa492166458e1d310e4fbd503abfc11dbed31a5ea8be17008cc25dbde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8805bb19d908a3d792173269dd99fd89b3e525f3203daa5b4e5ac2c293917282"
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
