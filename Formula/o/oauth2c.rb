class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "d75acbe4b456b30803aafab046270b07f1ea9ba76e525c671d2c83a93448e85f"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e520b90ef54b8d04101dc7634c4e84d9505ec2ffcd52791d989076cc9cdf15b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02012a9cb3fd1250e80d746e1664e00594b679822fab660035a9e9688dee3044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22d434d1e85370ea2f5cd7caa751e1d988cd99423f9f969de26139b927dc360f"
    sha256 cellar: :any_skip_relocation, sonoma:         "be6a490b33fe34fe573a051cab7df8c09062ce94f0c229619121c638055e20aa"
    sha256 cellar: :any_skip_relocation, ventura:        "bba17e3ae732f1f6ac0e0d430b8ec14279ce143169c00cd693304c13816624d5"
    sha256 cellar: :any_skip_relocation, monterey:       "99fb105f1ddb04af5a9fbb982222c44fc57457b07f48610a543b6a5ad8ef9dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9a35c1d2f3c55049b5b24207c7b841da69daf630fe327574f88eb7b807df28"
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
