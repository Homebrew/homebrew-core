class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.0.tar.gz"
  sha256 "6204213cd4003ef102251437341e103683c0b5be9bb2ab94d095d196e8da7725"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34ba67a480cb40fb2a049f217cb1d81532dc656a790372bdf7f79d1954a73af7"
    sha256 cellar: :any_skip_relocation, big_sur:       "96c15d7abe5ab134a8b66e5e4155960a11a8cd95ea9c33cf645af467db4c93f4"
    sha256 cellar: :any_skip_relocation, catalina:      "006bd2aea86fdf7e9689520d39dc44abb41ecba6ca3774c31dbaa6d29bebf391"
    sha256 cellar: :any_skip_relocation, mojave:        "c13f4182d62b920e4cb169be43cfc941bc0fcb3751a2d0c1d884f37e654854d9"
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
