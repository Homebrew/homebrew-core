class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.8.4.tar.gz"
  sha256 "9bdd6991e1b42a7f26262acacc66890061fed7e342321fc4108ecab810aa056a"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eba36b930c073bb4afe1402b171ac98e57a44d08794fcdb8517e0982351f3410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f53025a0c0d6a3a36211521acbc945051c3a031ddf779e37ac0fd3ec9d9e6da"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5d190122e7339a29455966c67becbfd812d68290991a5ca4fca41bca13d245"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03fa1c15d6e7bd9a05ddcb3a216e122c9bed353918ca57ca9a24b68a2b1b479"
    sha256 cellar: :any_skip_relocation, catalina:       "a49cb9a9a9071fcd6fb282f643dd8da1701000daceb22322815c9887b32daf5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ab308fb0d2bd6e897f2a440625d04bd54b9fd79f64585f9ec4ab198ee574a6"
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
