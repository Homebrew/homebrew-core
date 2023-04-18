class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.4.1.tar.gz"
  sha256 "be5f1f78e318d4dcd91b451847e02054d004ad8a013b6b34320a47c1e66c47d7"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b74ef9e27d48687af8d09e7a6a12ef5b5a6bc232b53c7913a5fa2c7dbf8201d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ca24aefca8892e71a1ced03551603c9ed1ff8d2888fa85f30ad942d0d825190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b99b1d53a00c84387cc518f523afb04f10a8ff064be11218691e565ea430eeb"
    sha256 cellar: :any_skip_relocation, ventura:        "2b2582980c302dd0caa61b3f0babaa66b70a26c7600a6270fd875081933f9343"
    sha256 cellar: :any_skip_relocation, monterey:       "838307de4f9106aa6f8162e4ccef2a298173b21cf2a732c438db6ee880495c7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d586544778409d52a139a0a0c00d1fa64071e8474ab6a52c97082aa2905044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b87a8c458d8430a7bb757f6bc185779fb110f10c5fff0c476021b944788b77"
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
