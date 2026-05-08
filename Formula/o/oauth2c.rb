class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "36606ec1c5eca7c7fff6bb87d4171031ddc5bfb93474eaf97191fe16b9902f24"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "496f8d7bdd55e8d793c97349fdce2d60be8cdc9dafcea75b78be79f3c1ed7d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496f8d7bdd55e8d793c97349fdce2d60be8cdc9dafcea75b78be79f3c1ed7d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496f8d7bdd55e8d793c97349fdce2d60be8cdc9dafcea75b78be79f3c1ed7d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df25bbe0206dbf3750f5f2761b4d83b4a028333dfe1647c5758e2b0d11c4ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "068bc90b3bc0b2386a5ae098c0a2550feb64625fca7ecfd8c871da14bf655dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7d1c31e096d50643c1b14ba5d83c1ae457e1870c67abf374e9ff8193fd710e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit= -X main.version=#{version} -X main.date=#{time.iso8601}"

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oauth2c", shell_parameter_format: :cobra)
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
