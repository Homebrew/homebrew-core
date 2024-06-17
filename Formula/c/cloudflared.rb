class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.6.0.tar.gz"
  sha256 "e75eec7eaf61320f7b5f9f6abc0891285bd3eeebad46b4a5cb53765281a8d88e"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23b531e7556efe1ff169e9c781a408fc36ef85be4a77229d79467d15b88e642d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c79beb9fd5b8ec3f7da982e08984f1260875d9bb2732f036b5507e62efa0a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc276f7cee0e14a04f3a80bc7418e3583e2835253427536a2e0652b5fd2a3cd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb57af75a1e9112d5992cb36302766e45887cfdb3779e42ed4167458dead89c3"
    sha256 cellar: :any_skip_relocation, ventura:        "c48fcb6f9a28c9c007a201c7431f9496ba110fef8234f91eb7129c61cdb51b20"
    sha256 cellar: :any_skip_relocation, monterey:       "1cee8ffa1dbf55009c7fa8c09b85cdbf5fd474ab83fd36730e35bd81de8ee3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b758e5b0e6851be31a28504ae48616febec18cef178cb966d07deb506d06e304"
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
