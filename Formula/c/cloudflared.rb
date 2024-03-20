class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.3.0.tar.gz"
  sha256 "6e5fda072d81b2d40208a0d244b44aaf607f26709711e157e23f44f812594e93"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38eac82efb2a98421b811b61ac8821e3a4b7def103710e401d40e6c44e2a1326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8172034b5a966c42c8c9f98fb0490c54bb0892f0e7db54b1faed96a214c6897e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f9695a3266bfb3e5f3782090bf2814a148ae898c984c5ddd0192643ba471e0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6b2bd9b0b96e838bee8d6d482a6321c6287235436b723c03ce098600c009570"
    sha256 cellar: :any_skip_relocation, ventura:        "ccc2b355d68bdf729fddcb8d730ef1d36a1e83f2e0a8354c039e1aecdabf2838"
    sha256 cellar: :any_skip_relocation, monterey:       "980bd828d071446bd54bd60328480dbf0f4ef2438c23f0623c3fbb46547516cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6965da150ac3f5f5eacbc37daf483ab84df026b11f2ecf6538eb77b640af0749"
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
