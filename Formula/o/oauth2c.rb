class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9968c76ddeea4153dd19906ceb7481e0c7487a45f6c48796c397a18e6162b753"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aaa0b07004e79eb9e1164e5d27db670d0803b38f970ab3dbe0d0613c5ea71fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aaa0b07004e79eb9e1164e5d27db670d0803b38f970ab3dbe0d0613c5ea71fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aaa0b07004e79eb9e1164e5d27db670d0803b38f970ab3dbe0d0613c5ea71fd"
    sha256 cellar: :any_skip_relocation, ventura:        "8afcbcdc3338f40f50c0c48c1a38e714aceb9c254fa43f4518b7719bff1c58b9"
    sha256 cellar: :any_skip_relocation, monterey:       "8afcbcdc3338f40f50c0c48c1a38e714aceb9c254fa43f4518b7719bff1c58b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8afcbcdc3338f40f50c0c48c1a38e714aceb9c254fa43f4518b7719bff1c58b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283dcbf99b3cf9b818143966d863393818e7581f9d368837530f372b36b1ce97"
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
