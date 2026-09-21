class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/SecureAuthCorp/oauth2c"
  url "https://github.com/SecureAuthCorp/oauth2c/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "f03ec7b08fa9612f8196d236658f6aaa3245ddd1cab6aa94a086fe5d938a0bfc"
  license "Apache-2.0"
  head "https://github.com/SecureAuthCorp/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0760551fcfbe5673c854be3edf0cbbb32eef47e9dadac0e3eff9b38ce77b0d4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0760551fcfbe5673c854be3edf0cbbb32eef47e9dadac0e3eff9b38ce77b0d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0760551fcfbe5673c854be3edf0cbbb32eef47e9dadac0e3eff9b38ce77b0d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e665041a1098d7f70cfe829f7431984c8e77a42269de4657ef8dec3506e674c0"
    sha256 cellar: :any,                 x86_64_linux:      "0aa3076d02dab34bf8c4ed4f79bc77949ca26300200b7ef8d914fbfef8b8f039"
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
