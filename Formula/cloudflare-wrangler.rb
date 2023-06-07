class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler-legacy"
  url "https://github.com/cloudflare/wrangler-legacy/archive/v1.21.0.tar.gz"
  sha256 "b3fb6b896c20657625777fee2a4199d24c9fc789f3979e950afc50c7cffb4620"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler-legacy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce1001d2bc5c2738bc18aa1c69eeab2686c097ed0931447c58601430b243be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ea6dd89b43cddfff5dc9ecb5abf1006b42a99b7c8c4e7c0f216da863812ba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca025f3f88d75d6476ab8fbd5462aaf731be6619736875a82d5db7fbc210c651"
    sha256 cellar: :any_skip_relocation, ventura:        "94d19e4c9aa48d2241e4d325b5b4ea617924c63bb70290af85a6fa9ddaa54e98"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8c6c5933719bb6041d7d74ca722105a8b04d83d402c0db264d63bcfa80c5eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "defa377444dfe24d83dd9afb000b8d554a32a63a5d167a0e203ed52d25caa243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09cc5e446ec78108aff2189b23d06bdcc2e6edcad7a1537dbbd1d793faacefe"
  end

  # Wrangler v1 is deprecated as of 2023-02-16 but will receive support for
  # critical updates until 2023-08-01, at which point all support for v1 will
  # be sunsetted.
  disable! date: "2023-08-01", because: :unsupported

  depends_on "rust" => :build

  uses_from_macos "zlib"

  conflicts_with "cloudflare-wrangler2", because: "both install `wrangler` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
