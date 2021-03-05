class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.14.1.tar.gz"
  sha256 "4c07a07e33ab48aa5c3e407c2ba0db0efd24d85422a12ccf6e9ecac8f00bcb61"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31157dc7dbc35089381582cb8ead021177b2bb4977fd4d06981a9c8b6c769afc"
    sha256 cellar: :any_skip_relocation, big_sur:       "91933ebfd5eeb560bf72bef8119c0fb2d57d96d6fa476f53eaf3c76b766d3606"
    sha256 cellar: :any_skip_relocation, catalina:      "8a9a939973a8959d5f0550285d345144d99e52d5372bdff68104e2abb70f8a05"
    sha256 cellar: :any_skip_relocation, mojave:        "2bf4ec75afe132efe10f38421e6c4be157d32b6bf85a3051f36c378392b66921"
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
