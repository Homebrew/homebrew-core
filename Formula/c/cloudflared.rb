class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.1.0.tar.gz"
  sha256 "f9223cdefaa4b75aa1c49638936af9d5007b6c7bd943ab70203bb75bf32467da"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c701af29531778c9e65109169c57c7c87fbbbddc0179c15863ee248649b9d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e3c5f2340a82782e1ae58a82291f6071aa9d67f7117258af4e882db895bd53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9104ac82b4f65f26f9bb2e6a73769694df2989cd165946bb26c75d189280dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f34b453ab85362bb5299ab167d6a2e813296627cb84d76afe83b690949b53db"
    sha256 cellar: :any_skip_relocation, ventura:       "9d7cf2a95edb1eb3739c9a9f846d88a5f63611a58adfface66d7441b02c45b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50014b9068c4912310958d2700be12de6af895a1e7b575ae4551a70eb4e44428"
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
