class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.10.1.tar.gz"
  sha256 "77403d5be313d9b85ed4e5dd9ac6fb6aab197a745f7a737c82bd33c71b88958d"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3537c16d9f19e3a078bfcedb2c24a09edb045036c72741f8451fa87182fb88b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "837455136c5026654edd1c8ee66f3301674758d716f3beb511da3720b62e21b3"
    sha256 cellar: :any_skip_relocation, monterey:       "6784ca9b184b1782e1276272216596bc066d319bf4019ff6acb5c073e46b7959"
    sha256 cellar: :any_skip_relocation, big_sur:        "105568f820ddf4f9d417029b031861f61d3b6bcbfdc59d1482d7dc6b7a39d460"
    sha256 cellar: :any_skip_relocation, catalina:       "541ce1907371faeee7ffe2997a37ca72c5e6c82165f8dd1625e93b533ea80bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccdc55b528b15288ab4ae1e247af469c4d645ad64234d423f9ec3f39934d7df"
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
