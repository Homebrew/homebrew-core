class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.2.tar.gz"
  sha256 "e32596b41a52930e69b515fc692dcdd134e1a05fdb9ed2ea4f5b766f5adfd717"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cc77083662fbb534ad76cda89e549807ef33ba757cd80c0349cae96828a8d1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9e3aa0b491cb7ef3fe239ece66482a5514220e3497d8f032afb6abf460d4709"
    sha256 cellar: :any_skip_relocation, catalina:      "5f1a43a2496b74a2f24e6b2778423c69b343ab99436f78e6f2967a4893872f87"
    sha256 cellar: :any_skip_relocation, mojave:        "879b8449d9ca70b55b6d9d2a1da749a51eb00e3380ead32d4d84feee693a5919"
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
