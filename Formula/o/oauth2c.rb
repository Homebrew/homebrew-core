class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "c9dea296abecb938ffa02e8bdb78bcd721443afd68b51b19d21db6fdc43e6fe2"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9233bfdada5406cc0fe44d3b2842465ab68d37393d5ce91537d4ff53cebf2b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9233bfdada5406cc0fe44d3b2842465ab68d37393d5ce91537d4ff53cebf2b7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9233bfdada5406cc0fe44d3b2842465ab68d37393d5ce91537d4ff53cebf2b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b664631b30a2f172ec3c8e309997f64bb7468d3b19cb6ac06ed0548f3ba615d"
    sha256 cellar: :any_skip_relocation, ventura:       "1b664631b30a2f172ec3c8e309997f64bb7468d3b19cb6ac06ed0548f3ba615d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9cb313e8e2ad54edb5b2b610fdc9dc7e3fb1bbb8ed2ede2f5b037a54e92b74"
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
