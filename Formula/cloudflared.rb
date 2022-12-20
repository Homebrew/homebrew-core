class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.12.1.tar.gz"
  sha256 "8cc5c41ea98a9d72687d5f62e733a9033191e834e4fa9b2aecc557f0ccfbda56"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "333f1856d26b26b0a00da1ecb43003f7f8a6dcc3ad1fd217854328728c989d0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511813fbd4c41c4dab40e0e06d1c1a91c1090ac7330170ac74ce9b8f00881818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a09fcd31c7f277f22aa97d1fe9a57c48365aaa334f373ad15dc76ff0cdb63a"
    sha256 cellar: :any_skip_relocation, ventura:        "2b8af338b4b8d59593d0663744f441d98d01f3be650c8d21a4004fa5269dcb1f"
    sha256 cellar: :any_skip_relocation, monterey:       "6990038d1cde1f7492a3bf5bb89ef7d77e444378d7fca339de3a25f105c1bbf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d2dd98d0ac6c5095e5c772a414b668d13159ab45c4f28e1524ca5ed6f819476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48e40f0907ca2726cbe558ebb549a9e9d44a352c7fbdd354683b496a2769df7"
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
