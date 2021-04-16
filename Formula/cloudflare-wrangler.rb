class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.16.0.tar.gz"
  sha256 "77447a9bb8d37760d257787f9559a7824cab193841eef33baea29766330b52a3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fced117225b4586b063a27d9176d33baba1051fcaec0a4519cddf4bc66e05fd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "adac32cfd1701aacc7eee577098c3d25b74b32b7aa122f9a21ec2ca029a2bbd6"
    sha256 cellar: :any_skip_relocation, catalina:      "5e2a412bbee09bc0f71f69f36a352f082de3c7eb53e46fe4df6afe345826f161"
    sha256 cellar: :any_skip_relocation, mojave:        "de86164d189eca1f506985d00f02b13c2d0ba13800c01ead86aa27c281eaa2cf"
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
