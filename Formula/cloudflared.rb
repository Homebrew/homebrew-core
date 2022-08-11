class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.8.0.tar.gz"
  sha256 "8200c1ee1064a0cdc222329328520ed3e93f689d8d0538095a1eb16b9885b1e7"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df59acddce1c943e7d8861da2e0b8cd7b6b9a3876048f24db534f3e69073d8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5193ecfa49b6c760cc92f7ad52a64d71a7b9d93f8828b734bec885eca0e1a056"
    sha256 cellar: :any_skip_relocation, monterey:       "1cdf9487d595b40d0f010a781d03fa26effaa4b2ad55a3b2ee37f10eed463a70"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb235551621d17a102a29924b79ece5e12f2a61acde0b1a5101c10ae0c4ffc84"
    sha256 cellar: :any_skip_relocation, catalina:       "63c17b2624975fa6893228271cfe1752192ae28748eb3b6886e46fdbc46388bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e271b7e7ed6c87b05fa07bc52f584f27b44192bec7b02a63c3cc62f5a5cac8c9"
  end

  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
