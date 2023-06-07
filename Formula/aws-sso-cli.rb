class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.9.10",
      revision: "11ec65288f78702a5e80078c04e0ef8b4ac7cb67"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f2319a761154b4ff20ea0d7aa4ac77f86dea89860ff9834a9299453e80059bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f859704fb32a05c3388c86cecea9e32e89a304adda29db602312db17b5201683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "420d7b967c0e945e7e02e22f230948b1a270dfae61fc80f3fc3cc734383936c9"
    sha256 cellar: :any_skip_relocation, ventura:        "c5275e4ad8a90a3f27286d45b51e2fef270c3ff4236277db9022b8f5e706fef5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e7f66e9747e1e05beed1e446fed2e7ba4ed52d7b85dcceb397c5fc80279ab3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ac91a86b5d87da7415b0f5d113b880b68607114f6f29e5512a3b90cbbdae166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98a479c79ab7003718f55f6a88792e927f01384dfa40f00c374c4cd9de9334bd"
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
