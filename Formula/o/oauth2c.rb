class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "87458914b1aa1ef813f76b8a043a1d8878209042ac0285d8c27d15d304d4a37f"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b42d16b77ae34b80666d17176086268421fd62e8645232322677513157f0ef11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b42d16b77ae34b80666d17176086268421fd62e8645232322677513157f0ef11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b42d16b77ae34b80666d17176086268421fd62e8645232322677513157f0ef11"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce6def395827ba177fc850f643b10582290ac763452dc0205870b0a14d84909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58705cd5857fc33badea91dc4bd5f20ff3b9ab9d88cbef6665d3bf800c6efecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b5b11a23e1a66f8b4e4840b8a85ec2e57eb581030f52e3c4307d0c94fdfab1"
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
