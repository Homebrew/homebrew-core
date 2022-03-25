class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.3.4.tar.gz"
  sha256 "e810ccc855cc25e8a2f33b42d33570edf97856b227baf4ca0def8e47a4b8d387"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "339aab302660b7770b2589795cfe88a3e694b6d8199a073050fe7c4919632465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e031db8d8d2fcd4ea620e834d83fab3c5a8cea09793265d467f794af3770ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "68c6adc7e99becd3005bcfa85a4ee54f7f2ff77e88db34d46fcd1dfb71966085"
    sha256 cellar: :any_skip_relocation, big_sur:        "46e4fd6bb0a63a0dc0b00c0131444120be8da950c6bd52652238fe9d677f1677"
    sha256 cellar: :any_skip_relocation, catalina:       "f52320fa294850b190b59c943c348fbf2986d3cf3a9e67197b73142142d2f8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c7fff170c8b4a8688199718f2a81f23c763f5ca40e39f9caf1a4c14f81c701"
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
