class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.10.0.tar.gz"
  sha256 "f83c1ab042e7b15da69d2e7764898e0bc30f94ecd7db36dbd6270ebade1d5d27"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac47d7719bbc96055bbabfd5bab81c47b3515f28528c6124be36e850f94fcca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3dd166e2564f7138408035be44e68f00c0042a025eeca71e2659caaea75e91b"
    sha256 cellar: :any_skip_relocation, monterey:       "2dfabf4be839a181e030e35634962f7411c4090401b82485dbe54f10cfc061ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ad88e6f9049ecacaf32900780351f28e5b3413ec39220ddfeed82b47f259d9a"
    sha256 cellar: :any_skip_relocation, catalina:       "d12817bf7c9b13a244d8fc12068a4a32d6e6178ae81cb4ca9250a8fc5b1a6e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d82c88d0509621632514a77cdfbb85fe3be28273b131c14746ab50c407250b"
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
