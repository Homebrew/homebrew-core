class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/SecureAuthCorp/oauth2c"
  url "https://github.com/SecureAuthCorp/oauth2c/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "8f033f91e14bddc3ff3ae2c7cdf804f4e794d94dfa0e9ef4751d9b9d9cd212c4"
  license "Apache-2.0"
  head "https://github.com/SecureAuthCorp/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d75d44a4993f6232df595f26415b5391523d2bf5f81c0f8ec355a8ec731b0be2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d75d44a4993f6232df595f26415b5391523d2bf5f81c0f8ec355a8ec731b0be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d75d44a4993f6232df595f26415b5391523d2bf5f81c0f8ec355a8ec731b0be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c99ff220b799c8fe151c963564b8a657f1d5081d52c2a6e9ca0380e13784999"
    sha256 cellar: :any,                 x86_64_linux:      "490575b781e17bb1df816f758a177f6d2f9cccf7019524b2dadd0c1e9910f181"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

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
