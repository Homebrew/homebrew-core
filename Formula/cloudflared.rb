class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.3.3.tar.gz"
  sha256 "da352ea84032f8d1143b239041e8092eff0a35a4966b63cf46d073522dc37672"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0352ac06b86b91ebfec6de82e454cd2e020f6f00e77faba31220d9a30187ce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05dfbcf4771ae091abda834284ba71dcc545790c000bd5a32c4d3ab8e62e33a9"
    sha256 cellar: :any_skip_relocation, monterey:       "530f2344ffbc20523bd80964c75a0f24bd550926bbbb64fb7512cbe163270a44"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e1e3a05899e252cb321f4cec573c09f8372ec51ebdbf85f12499bace9ad6803"
    sha256 cellar: :any_skip_relocation, catalina:       "44a6acfa04d0b8d1b703e2067bf5e5033a687e7fba38e7892142e49d5077d923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0308e3298dfdfaedbfaa6c82aa444a1e5c9cec849306e5c57e4c0a7c023b35c"
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
