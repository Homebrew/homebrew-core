class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.17.0.tar.gz"
  sha256 "f9b4f72e44be3b7f2264a0c22425d4cb6e75b28c2751a633eba4bde055a6f695"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5cd032b5fdd4deff18e9b63e11b9670c26606e83140cb90adbe8926d74582816"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f0e78d71f1d68587f34d352992b7c836ac66760dc1a5596b29ccf03b898131e"
    sha256 cellar: :any_skip_relocation, catalina:      "54e5192e537363b842e864ddd64ae45b8e26008186d4969929a31f992407451e"
    sha256 cellar: :any_skip_relocation, mojave:        "375382f810e31f783169c8615414ba028cc102a84360483149f123c9f62222ce"
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
