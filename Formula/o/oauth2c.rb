class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "ff2b46b344b3444e344bba336fefe6e7706b3196b69c4e38c9e95dd527110745"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e75715a36d6ef6248ca5d9ea3c3640a84f56ea674cd473dead06e2c5ca30160a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75715a36d6ef6248ca5d9ea3c3640a84f56ea674cd473dead06e2c5ca30160a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e75715a36d6ef6248ca5d9ea3c3640a84f56ea674cd473dead06e2c5ca30160a"
    sha256 cellar: :any_skip_relocation, sonoma:        "212dedc74ce1045c7d9ddfd7c6f7b5bbafe868598b33e29a6b998d74b9a6f825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451c6e4bfef376b6484a2af2e95a75fa2075670ce4a521e41a46709c356955e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff01427c8c97ff748c92541c90d2a1274bca0853011afd944ab6acae4ec619c"
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
