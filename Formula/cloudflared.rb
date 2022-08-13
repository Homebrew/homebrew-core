class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.8.0.tar.gz"
  sha256 "8200c1ee1064a0cdc222329328520ed3e93f689d8d0538095a1eb16b9885b1e7"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3855c75339c3d91ad9e5fa5aaa6bd1126d38b07c3806ea3707ae5e49abf390c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ada2d71de0833d5d7d5e3420aa7de5ee8599b8eccdb295ef16ac2b298bbb00a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddfb12bca3d79994a0cb737263f6a03201b553110fc14567eacc5f1a9990eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "abfea8aa39c55cace023cd45e6a25b1e3087b9dcf53e51c5075e4c3ea65bcadf"
    sha256 cellar: :any_skip_relocation, catalina:       "dc47e5b41f388639ad4c3245719b884cfabe27a4e810f746323a5988b1c572ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1391a70f9871ed051bfb3e76d3c9c02e236dad0d79f5097d8c92ed8fc65d5d7"
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
