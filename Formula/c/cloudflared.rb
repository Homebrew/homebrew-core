class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.4.2.tar.gz"
  sha256 "2ed887aff0f14cdaba3b35bb47343f25cbfe23c7e1f5ceb94c2fc005ccc23666"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca08bae8e7cd82a5599df0f0209374913eddeb8534468563f9d422805b8f4f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dee57fc7becbe8c492ecf9f8c443ddf35255a37babdacefc1b912a0a0dcd9408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6b9593c54c8d2e759f25c6c5cbedc66b2e4e48c8147c09512bd45ac72bfaf67"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb318a7f9a2fa5505accf18a91e4ef101df350554e060719edb810815bc2c582"
    sha256 cellar: :any_skip_relocation, ventura:       "6a4c3fcf0fb00eddc09d51360141b3556d443370aef911213bb6a1be0580d36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b617559fcb99a43c1ac46bef33ee41f77cc527c59a37e8823b29fd66a6f112e"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
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
