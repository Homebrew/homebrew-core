class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.14.3",
      revision: "34131edd68385e7262c4dd2d742b4066c9d7e074"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f8c1827045ef796c9405fcd26d670154b1969f119e1eab4ca0411d13e269da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed6eddb8d6283ac5ca8593b1c40a84b57dd7390a69453e7c4d70e9ef463c9ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1746c5b132fbf262e6b62d42e6c7e2add9a9a10c0de307bbc654e1320f4e683c"
    sha256 cellar: :any_skip_relocation, sonoma:         "28dc890838d0e388314f9a22618e6fd1e9c070ac96069748d76c02995827a495"
    sha256 cellar: :any_skip_relocation, ventura:        "b06e0f821126a20be2b97f4c7b771f1e11f92a4e9580731c949fef99beae63db"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d6fbe5f5f4ef4be8981fb422213672852f00bc9e084c7255b14c38f74f704f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08651c1e268d793d7c91e47e2ce6a1e728620722d53fed9804b8d5d358ea1062"
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
