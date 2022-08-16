class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.8.2.tar.gz"
  sha256 "45ff0c9b95997e2f1795b08af5c3ed2fc19d2d3cb35391c01452163003b858a1"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9c78edb4db87000db72f3c6bed9bc4c55098add3599b1adbdbcf2de45e84f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed1edd01244a6d28b75c383da695e23224e8000319e1fd0fc5f8910c346c84b5"
    sha256 cellar: :any_skip_relocation, monterey:       "9bcf5db0b997c3d5031f203ff25866d4bce9089c791fe3276db9c18c9f219aac"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad9e5b210c03d1c4219d372ce74a71922bd871b3f29df254b44a1f5d95cf041a"
    sha256 cellar: :any_skip_relocation, catalina:       "e61dc61c17fb5cf3480f304ae36c4099687e2aaed17fd8c3c8e4b100637202fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d426f530de2053d34d23a794261ebc5fad093ce46275c1329e2c3d1702b1e298"
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
