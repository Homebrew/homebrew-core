class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.15.0.tar.gz"
  sha256 "a48a5eed79f0362fff7c9dd8806d010d60054a3121ef3546ac864a041dfb80f9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "080bfcbb62139edbc6f8f51e2521de0fe3885ac8fea836358ec1712f1ebd16fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb0f88203f8297f805b3cb566f821078e108442e81153f6eca44ab54b88820b9"
    sha256 cellar: :any_skip_relocation, catalina:      "69917d50985d68f4c90f7e6e56faa5d0441c17b6b312073743707d0977ced17c"
    sha256 cellar: :any_skip_relocation, mojave:        "1d090bfd3d8ed2c1dd9ed90af24666af587e16c81a3b62a0a9e93a6fe383a0f2"
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
