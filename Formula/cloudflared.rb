class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.6.3.tar.gz"
  sha256 "74fb20e78f69db086f6044eae9d7a09bb3b59001a14d17c18edd9cb4ee8db4f6"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba7bbe95f51fd4361740ba83676e897c5f4594fad17843b9e6c713f62bc6223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f1ec98f5e3256f88bfa3a1c10ae63f2e64486a9b54930c66ceaa8013bbf0c01"
    sha256 cellar: :any_skip_relocation, monterey:       "a918fcf45d9a85eff6792883dcadd101f2e4b54ebc5e40f2c34bf698392ea2f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b553f6d6fa13e983ed24537ec1d987dc57a26e654f78c669e1d8834bb9a7280c"
    sha256 cellar: :any_skip_relocation, catalina:       "cf43da5945a1d48a80b82b3f52d77a887b6b64f4ef99f9858d3dc3faaa99c115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9d62ab4f7acf3b4ea6932805a3fca842ad1ff9e3ce852d1e1b8f2c33b9d9bf"
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
