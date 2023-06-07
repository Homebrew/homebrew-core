class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.5.1.tar.gz"
  sha256 "ee2c2a4b0c290c39475f79ab74972dfbce817df8e5090813cad0e58f33836194"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b4bf0f68b125cf0e97ef2e9fc28ce9de7d1396bc997a3b538130c9472715ccd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "387e523dea16922300ea096edc45f115ea012c502a3f940f28c485f66136b4c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f38c9ed98f1b3040766189a987abafdd8d65e1ae28a519d357f36e30b28f801"
    sha256 cellar: :any_skip_relocation, ventura:        "b5da5feacb70b02103a81a1f8f7788b8b75a5bd64c81c76ac86adc7ac63a30bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c413aeaa14dda20b7bf32a4f57eee86613c36d5d19613fcaa11e112ee3e2f71e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17b5256969611d19d7db4e9f66e6d271eb575909a42963d25b1d364d9d0a4983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5ec8fe1624a7761d6faf81f3140c7570620578bbe7c13110ed75d4363b8dfb"
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
