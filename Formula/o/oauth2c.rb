class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "22c3044011b0d7adff925b4c6266e78f5ebcd7eb1065b5c9239b5c995a9c89b9"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, sonoma:        "975b70217cd3e9575fe3cb7c535550e206b2c350dc7ae591ee1e9b6a36f4487b"
    sha256 cellar: :any_skip_relocation, ventura:       "975b70217cd3e9575fe3cb7c535550e206b2c350dc7ae591ee1e9b6a36f4487b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3948da012d3d9ed55544664df1d8b3ac9e10919860128b2ba359c878f9850180"
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
