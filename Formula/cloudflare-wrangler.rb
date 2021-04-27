class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.16.1.tar.gz"
  sha256 "8fc196af3e87085fcc0b211b2c3338e34f4de20161eb0d70caaaed2d84a159ea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bf41e090f74d5bebe0b63f6b889a326e3dd9008ac0504f1d4c61c508eb9d30e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6d63bb03be8fba558ac98d2ffcd00987ee5b92d2434bad1d74a751e81d6d3fc"
    sha256 cellar: :any_skip_relocation, catalina:      "1ed666be87d30513c032ede0c3208184cd0e4af724962198566a678d43fb883e"
    sha256 cellar: :any_skip_relocation, mojave:        "e50fdb5dfb6d9efab153ba20a831230ade641c27954151364aa74d9b82c336f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match(/Code 9109: (?:Invalid access token|Max auth failures reached)/, output)
  end
end
