class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "0abdc09cf974948fee751caddd0b196203145db50dabfdc23a0d0a228d88fd3b"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "704d0ffc01828979c9b8344aee977ecf1182847a01cbbaee8975c85fc55e89ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f389ce7e7a758c7aaac1a2e5256332fc696ef545271d8457f64693ffc95826b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4edfc33ce34686b6fea27251fa6f0748d256731c7a5865207c49e6e8c3aeca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f458521cc6fee5c204f59f7844c24ad1a0a33a55af5ce3b050a8d7c6cd36318"
    sha256 cellar: :any_skip_relocation, ventura:        "df4ca907b933bcfbec81a1b4779252736513c007a8f884b471564eb24a1e9280"
    sha256 cellar: :any_skip_relocation, monterey:       "8374d4eec070b77035c66e34b59d1097d57d8582e802bb8a8630eef8a09bf0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24374acec98eddfade5e839260e22e23117a2d9873cbd49500c7085d48f35138"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
