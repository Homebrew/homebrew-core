class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.4.0.tar.gz"
  sha256 "a68882beb5ec2855a17253a751295c4cc4f8f9ca3b49920ffa7e398995f85055"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45cfb6a47b8fe7fbfbb219ca9dae8f29af387c6a4cf316278f4ec5fd8ddd3678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "361f19045382b7d8dd06e0036fb786540b07cbdeb27639d00218cedb13ad9695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07785e874bd35bec698702b1b5bf74f4737ad371dee4e39e095d7aecd97436e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "31cff5f27e227e2ce861294d982074dbb9f779f15bfaa3eafcd3b88eeedead20"
    sha256 cellar: :any_skip_relocation, ventura:        "99c023f25ee785e5b8aaef8b9730a8b97442e6ee44d42823a8d4a3669c278dc4"
    sha256 cellar: :any_skip_relocation, monterey:       "f6102a6f1b9403d08009d81cfe893794dcb19039808fcac235122f3746cc2eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95634880d22f30410e5c010d978af9a130c86a859cc9e07a27fbaf52d07d37cd"
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
