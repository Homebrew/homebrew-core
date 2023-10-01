class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "db77d4fb21f000589535b135a4a32c7965d3cbf21d92b1d428d4bba60743baec"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78d191b203cc8b6573fb0cb67b8c47c1bb81e2171ab72881664e549aacde19b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f59ea6d289afea9164d55bb07410300f7195013de164330da8f5aa6f30c3c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a5f846fac6134c42fbe70e1a1a530ee432fe9541c7649ff7c0dd06d2eded7b"
    sha256 cellar: :any_skip_relocation, ventura:        "52b52f339edb62d0a2756689f740da6dce035f0f858fa4fa80d79f3dda62ba6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1dfda0e8be9e1881ae91a1a03f3375008dd8365dd4da3d28fed71470bb7f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a4c2fde629d1c941ecc21c78492c44eff5476cb13d85147c52ec878fa7a024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebfbc347a546f333039bfa4d47a6970c42fc21e53a33d6afb5b6c512cc92c67b"
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
