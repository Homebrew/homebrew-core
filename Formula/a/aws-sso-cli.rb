class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.15.1",
      revision: "e2ec94d101ba9f9c8af8d766d3961f92e116a025"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35786787cfa8317d878038738f1c024184eb5ca3f6dd1b886510fc3b97880e33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbf061ce4d268d244f88e8e96612913ae7f0e371ce56d6579be0604db158513a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efd0a989bf4ae8fdbc4c57e6fa1f2837a4a8995f7b56f625b3782a8296087bbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "463433d7d16ceded8133d73d60e60d7fdeb39794543c25e0c0eba03078d78b22"
    sha256 cellar: :any_skip_relocation, ventura:        "bb6235800ee66cd94dcd3205569259f3584f48883b4214c16db2c9c4f6a73666"
    sha256 cellar: :any_skip_relocation, monterey:       "26b69d185dde783e7e42ee9b49579d1f941808405be7f06810e5a9cf36086a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d6e8627a3acbbedf04dec38d9ede0ed2bed41a771b02cd70791d0deca26703"
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
