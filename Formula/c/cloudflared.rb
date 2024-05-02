class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.4.1.tar.gz"
  sha256 "11bed2bd793cc03775aa6270797ed328434bc982e09fd3597e267590f28d2436"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40f935297f1c691338ce2278d84fdee0316beec97d8ca24ad57ac094dd3b69ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27dddb8efd1c2f7fadca9aba2bdce3176d528c49ba7c8dc7607e991edd474f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9072c8142d66ae8010df16239cb2434fd806c7c89af4b935c97890009eaf670b"
    sha256 cellar: :any_skip_relocation, sonoma:         "93f66a7e377df7160db60ab12da66acb78b50844c416176da9968149eb002398"
    sha256 cellar: :any_skip_relocation, ventura:        "592ad7f3d01c03f1d26d5b7d3033c02f1d8ae1b4a6347b4be223ad358b925453"
    sha256 cellar: :any_skip_relocation, monterey:       "bda69bb8d95a6be1fdcdbbd87b059640581e960823f64e1b4080cbb915aee9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccdbe424f0f1a494cbc110019f0cd1c932fe7c9a64ad999393ee545613466164"
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
