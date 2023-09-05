class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.13.1",
      revision: "7c08e58ad2a2c941bfa42ad98b0429f3fefa1ca7"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58dbeaad8daba32d282ef12874afe5306483c8b0caf64c457d338712fb45e484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67c24a08767e6e6ff3109343e4dbecd4f4a4b5900844df5f93367f267da2642f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "016921026e3dcfe308a4f52711e3cd42a371441450c8e03d87fcc1d1242b671f"
    sha256 cellar: :any_skip_relocation, ventura:        "060323302527f299e1561481a1e1af2ddfab04c69b3687f9db3e1f756e7095c5"
    sha256 cellar: :any_skip_relocation, monterey:       "eee8531702ec69dfcbc356494aff250389f6fcdb5e7e6ddbfe4136ce81e6fe68"
    sha256 cellar: :any_skip_relocation, big_sur:        "635e730208a6dd5213ca78ed20c1978910febdf3de3ac1ed0cc0c5d2f451cee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416552e81741edb2a9a96ec1dd2498533c2ae9396ae7bfd4ab569461f0b95473"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
