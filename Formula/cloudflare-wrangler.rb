class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.12.tar.gz"
  sha256 "42414fe79b089251a6a0f12d63dc635e5683825449e8960f70b66b810e5a60cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9db0420ebd94c15f4105f256f51e86b6e2de913376c28ece96a16d49e4c2156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817aafe1ff5f1e6b8ef0f8621c670abdf9a2a21c53eccfefbf37e36db352d3da"
    sha256 cellar: :any_skip_relocation, monterey:       "ef78b187116ae4b44e09d11ce6e525414bf45023cfcf4e5dac8be415218aaf7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5f4b128976ed4c2ade0ca0574be3262d9c1d27c85ae200f7b35a0995b924a02"
    sha256 cellar: :any_skip_relocation, catalina:       "9e4e3bd3be4a62b34bc8564ccc922ce96c844443849671940492a521f0d56c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b7af18481d3b31af4579065fe4cfaeedb4a58b4cb7efbf58b3cfe5bde8c4b9e"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
