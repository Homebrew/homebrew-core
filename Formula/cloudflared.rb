class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.5.1.tar.gz"
  sha256 "9ddf09100b3c9ee8c1a0cf0ba3d5ff85ee04987bfa51e885a32dec83df5dfee2"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34cffd5f93547f9d5894748b4255cda948f888410e31026d2b7009df72124397"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b14a7307770c46218226d599fa61a043604f2fdd749306f33a77d8137954911"
    sha256 cellar: :any_skip_relocation, monterey:       "2386c5997c872a856a93aa71110bd8ed7b0a5cd02a10ff41a4d108ced46aad02"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d0ace0d38095cc76671d28b09fbbd27e858dd38a142d621514155926458516"
    sha256 cellar: :any_skip_relocation, catalina:       "faf2a5068928198b9676be938664375ee3a67a59b8d66bfde98fcf4be6597a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20dab0a31fe98e88a84f87f45712324a095e6aa4781743c802d5790309ec6750"
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
