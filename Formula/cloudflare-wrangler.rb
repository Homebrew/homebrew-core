class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.0.tar.gz"
  sha256 "6204213cd4003ef102251437341e103683c0b5be9bb2ab94d095d196e8da7725"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "134dba92a215606b83d8cd5001fe8dea4cdcbed5eab2b6d9e19f1ef96970c0f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e8caa36ba4c953cc025d79e7b4d1866a4572c33a3b09534d6cfe5186ea43dc7"
    sha256 cellar: :any_skip_relocation, catalina:      "dc59e29e409d58a1b5094bedf315f4319d60246349418d3821e15badeabbc2ca"
    sha256 cellar: :any_skip_relocation, mojave:        "b117395b496546b9006406463aef8012c2b5472ffbfa8619a5bd634ba5225a2b"
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
