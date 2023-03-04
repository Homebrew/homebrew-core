class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.9.10",
      revision: "11ec65288f78702a5e80078c04e0ef8b4ac7cb67"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

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
