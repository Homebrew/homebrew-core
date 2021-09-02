class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.2.tar.gz"
  sha256 "e32596b41a52930e69b515fc692dcdd134e1a05fdb9ed2ea4f5b766f5adfd717"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22bb491ae6733f851804a6f4f70e27f25586e910c39b88dc8d9b5b494d0036f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc2b1ba3e825f98a1d19332a0e18dcde2c7eabe1c6a2d574a5e3604060e752cd"
    sha256 cellar: :any_skip_relocation, catalina:      "51f33e748352d7e5f366171cd4be679c3cef36bfd72583c92bced4a385e10c8d"
    sha256 cellar: :any_skip_relocation, mojave:        "41f15cd74fdc17cad73f7a2f81c179a6c68f06cac45d843d6aa7872c04edfd0e"
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
