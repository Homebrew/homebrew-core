class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e8cdffb23789d3b3fb35aeccf4e1b58638d349d8255290af6b6fdefd2cd9ff41"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8abfadca9121fac1df85a8b79028849cc7f07a5f4947e8db5bd9340e0e3fdf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff2cfa5f2c77303c0ea6eeb5586f7e5dbc62bcfd8f9ce1b0db8e97c58ceac69a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13abfd948aaf2b4715ad2639e0cf8019dfff2847303d59a1f2477a49996822ef"
    sha256 cellar: :any_skip_relocation, ventura:        "97a4c01ad662672696d029b799fddd9316ec3bab2d768ab343e0df498445e463"
    sha256 cellar: :any_skip_relocation, monterey:       "da79871bf16059e3690faf7cd50dcd7ebfb15a0f4187e98d96c43360943cfa76"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6a9995234b6f95ade4d58de10a9d1387f79f8655f66b048e1077c10a83d89c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593a8409b22f32bf0168a1717ee2b2101c985dd99f440c63acd75133b90b4d9e"
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
