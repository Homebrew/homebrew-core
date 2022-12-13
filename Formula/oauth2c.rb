class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "5eb6992882e8f5ed6e1cbd2653634e15860e8c5b8d9cd5fc7db0489848198dd9"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "209a9dc0a003c299ee67c608b60eeb1e952177e6b061b0f065b8203f2644ad77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "300b73c74a67de452726936adf318dbab73d360ea346b0e293c62376b99d162d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c54f33bd887fb2895d5c8204157d383feb2b90438982788c9c881554d029622"
    sha256 cellar: :any_skip_relocation, ventura:        "8652ed349ee6d1f69b84cc953d660bb2f359459275b66665b5074aceb661286b"
    sha256 cellar: :any_skip_relocation, monterey:       "d79a15dc69d3c01b4b66b6f4d801e0fb03101ca909122a849d0e96f7ecb34f02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f743df8e26053b6b06eea3c7b9126054e6191125e06f19f070f8a9e62eaddf8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87846912d31fca2a73c294a345bf3116ac1a61305a39a71b66f6ccc7d9b0a4fa"
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
