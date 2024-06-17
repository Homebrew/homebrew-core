class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "6f2de82541aef816763d6458eea06ec93d788309d2563974931221a0e2cb4286"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fb8e261a101b3fd7ea005339c75b3dc513913312769d6d1378e632a4d18e130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e576794a359b064a1a0b37068b0b1822d4f95dd526b23f6985431ee13d1613a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd32fb7dd4e620ed93f22d30ae79e1a987b2106ff0c6c2fb9dfb8a937dd50ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "7de2d621c168aee33ed3500492d1cbb5c0aaf24c23538431eac255f8077d6a27"
    sha256 cellar: :any_skip_relocation, ventura:        "bd12f2cd324555314280279d9dc82d2f04bf5badcb22482068011e172a7b6272"
    sha256 cellar: :any_skip_relocation, monterey:       "e40e024cb93e84d1a88dcdf50e814fbfe8d80b272ec82f0001d487eb4a83e35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7109870bc9261198f43b24163591e44f93445ee3cad8c5969f7912afb65d4fa2"
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
