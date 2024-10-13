class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "367589bb203347df7c63b413a2b39a1a9f9f6e125974b662932c10949fddae83"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f7c393a74886ddb076c3e4a741a92c66475b42d1fe02bdcda4e082a29f86e5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70d78e0f5915856c6ee1e4b943d0010b11b9b327ea3f613dadeeebfdc8b0e123"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d78e0f5915856c6ee1e4b943d0010b11b9b327ea3f613dadeeebfdc8b0e123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d78e0f5915856c6ee1e4b943d0010b11b9b327ea3f613dadeeebfdc8b0e123"
    sha256 cellar: :any_skip_relocation, sonoma:         "beae09c09015b3112b922e046b62e921d743289a8ea024f25ec65af046307533"
    sha256 cellar: :any_skip_relocation, ventura:        "beae09c09015b3112b922e046b62e921d743289a8ea024f25ec65af046307533"
    sha256 cellar: :any_skip_relocation, monterey:       "beae09c09015b3112b922e046b62e921d743289a8ea024f25ec65af046307533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f816bcd236dafd4150fef77600a5528b150bedab186554aab0ad4ed61dd27ffc"
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
