class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.15.0",
      revision: "9f897c5be301ea1a3cd1b143dc75d0d2bff5e500"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fc117f8e9d0eba2ce6b6e41d74d1aa1f43ac926d44998d299eaed9461d4918b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b25c33943707a39c74ef04b10eb49e2107567d48c7caffada243b54e30f26571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7d2cce7454407147ccc186157aa8e01953bbc9984076eea43fd47e76eca738"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e4763c9340dcca56ab1809a26928bcabaa7f98213d7e126419bac2062f71d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "9f8a4b368add249940454ae4ac481d66726aadbab08e91eb0ad2903eeab9868c"
    sha256 cellar: :any_skip_relocation, monterey:       "5ecf3b80b02d19c62d678bf9559f3902fec58bead984cc77e348f5a69708ee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37b4a78265f547051be47c1a55e31cf0f816d2b69c2671f97cd4a7eb07866982"
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
