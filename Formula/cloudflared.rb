class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.4.2.tar.gz"
  sha256 "1a9503ec66f03c5851fc2fa941a81cb3520ee66555550b2bf49da931a2e8125a"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84391a6311dbd81be3f995ece2db611594f8e94415677e5216224493e8b95f1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e721a41af0512ad96d01f0cb12db6b4dc3e581735fe598be1e01835dd4d0345c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b3cd2ebb63a1a17a3b138b2a0c09e5ad08f34f42e11ac22f325af3b80d8cbde"
    sha256 cellar: :any_skip_relocation, ventura:        "cb34d84361c6d5a631c253a45af616a8438979c53b527afaf5f7ebdecbd467b3"
    sha256 cellar: :any_skip_relocation, monterey:       "00a865b47aa6e11892263659c35873d7e8fcb3f5a57cb6596e665deba3578769"
    sha256 cellar: :any_skip_relocation, big_sur:        "a80fd7d56735462453d2cb8814d0bb0aa2b63543f5c6a757eee8336998485afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1099c697c5fee1c506a4ccf96d418584825dfbc75d3d9274317601f07c555b"
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
