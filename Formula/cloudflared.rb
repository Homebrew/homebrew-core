class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.2.1.tar.gz"
  sha256 "468b0953eca6ab189859073067857062c91ed9adb18e12a43527e0dba3aa6409"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36297c8f88d365677b7e7079455660fc64f7c5d8f4b21a38f23f2cb2c550f0fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a43a59f05769042bf5ad2c75a917ab02bdc1b8b2cd3de55ca3bd90331e58a8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "575e0c2f2f7648df54d78b0d31824e32b16152222b870113068a5be5c7c61aa6"
    sha256 cellar: :any_skip_relocation, ventura:        "ef825ce850859727a56f2a82c5da799b7eb3fbaa33db99b07739c4624978fbec"
    sha256 cellar: :any_skip_relocation, monterey:       "5eca8c8482831338d8a12cb1ee6cfb752fa29a29e41ccd7e0a3b515bc7707c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d11ee88256cc3c6a9557f0196c65f0ef4b5be720d11632ed1ec17da8cef47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2e729603eb85d8274d5504b58d3aa13fec98244e5a3e0bdcf5b231a0cf713f"
  end

  # https://github.com/cloudflare/cloudflared/issues/888
  depends_on "go@1.19" => :build

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
