class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "87458914b1aa1ef813f76b8a043a1d8878209042ac0285d8c27d15d304d4a37f"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464c3b65bb50f51bd2a61fa89582801b9420db58e31eb978b0842a91d1fdb259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464c3b65bb50f51bd2a61fa89582801b9420db58e31eb978b0842a91d1fdb259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464c3b65bb50f51bd2a61fa89582801b9420db58e31eb978b0842a91d1fdb259"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e4b119f8eaacd454bd2f2f90d3a6cfa7e23fea5fafdd672a2e29a857181fb49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baedcb78680c53e08ccc596342bd3a8bf239c2ebbb61bbe0d7127c47bcfcd768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09a2161be9f9da16d6da8490838446b08f25809ae63a0760a772459c77e37c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit= -X main.version=#{version} -X main.date=#{time.iso8601}"

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oauth2c", "completion")
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
