class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.5.tar.gz"
  sha256 "91683895f1b382d991e7aabddda608c1203cd5ffe01b87aaaeaf2aab6d41e0c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f7c206ebcf91257c5aa2e566c59d408f16227f068434b6ed786044688e4107b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47ccd7fe5966657ae1d858161ec53da790b5c3c186ff7dfeb83f8838821cefd1"
    sha256 cellar: :any_skip_relocation, monterey:       "1d381ff1f0e6390e69a959622d80d1e46f39b959ff72468de03b17fc8e8ba879"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ff6a4000be35f6bd92253f2710924849c33e0d5f2f32bafbf3e17aaa1ddfb22"
    sha256 cellar: :any_skip_relocation, catalina:       "06602df7c197b03e4d5962f4bbbeec43e185bd5f5c857bd46ad0a9df7c6dd9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca2ab844ad692d182fe85121d8404263a37224c56a700a18258bdbf8e871279f"
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
