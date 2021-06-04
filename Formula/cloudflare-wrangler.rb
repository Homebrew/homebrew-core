class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.17.0.tar.gz"
  sha256 "f9b4f72e44be3b7f2264a0c22425d4cb6e75b28c2751a633eba4bde055a6f695"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32fa9d9e42054274b41a3e96f06c47256e0e66bd5e73c6acd766807a8e70cfab"
    sha256 cellar: :any_skip_relocation, big_sur:       "75934a47ff7adc0ead4eaa0630dcf479beaadc0c20390c128f99d132dc8ad94b"
    sha256 cellar: :any_skip_relocation, catalina:      "e226bbeb537761d989c1245e0185e5e56370de9259854ce0afb5e70e9e98ce96"
    sha256 cellar: :any_skip_relocation, mojave:        "bb5e541d4cc887ad4980e284a7dc0994b34bf5b805eef3aafbaf33e883752f36"
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
