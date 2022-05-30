class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.5.3.tar.gz"
  sha256 "d5d55a143afb918dad279490bc36e4d3537c2b862cdecfcd5dfe5bb52af63e7e"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f26c0f89a25f3f1ae5c97408183ce9d5b660c4ba8f226d7e8c69d2d650ee10e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45483571dbfbeb27074b18aeec8b46e409fc3e0aa697e8e821cfeba8b9796be7"
    sha256 cellar: :any_skip_relocation, monterey:       "2f681f38decd55d911f33c8f597b1816853e76ae839357ec96375d2ab0560707"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e662f5523dd9f09b21cda68ec58072b9ccf10c6551b7c9ec2d6e62643e3d475"
    sha256 cellar: :any_skip_relocation, catalina:       "47525a856d43091880f9c6850db92957da1f344375304bd3b227915a66fd04fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e05ce7a1362cefc04a3d8fb835c28c8e8a40507f7c5bda8f22eef16cee138a"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
