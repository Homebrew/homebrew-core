class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.12.0",
      revision: "76ef9401fcc427e268542f0c907189804b94cc4c"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16d08f814982d81ff684e09b0b15e498bcec4fabee2f8bc58b8594c4c6fdc5b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21e06d5304acc7445c73f453c827a5eeaae6c813435b740dc3a5e050aeda440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d48d58fbf78ac4ab877dec1757fe297402d6331314c887c9f20e95175092d180"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8f41587b9ca6804fdf23a380de060ce66a0bd547157103aa78322f3e3b5966"
    sha256 cellar: :any_skip_relocation, monterey:       "106ffd33b68e9f02fd3b47da8a35a8e931b2f0a6ea57a9510889c7c93781b890"
    sha256 cellar: :any_skip_relocation, big_sur:        "035c830d144a2966a4ec5561501ffc5216c7bfa3d69231a47357c05d3ed59afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834cf66925835fb4881edd1097a65edfcd5c6379cb007ad18fa53b1ae57625f9"
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
