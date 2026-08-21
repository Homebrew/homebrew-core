class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "faa8deebb693cd43d62f4c4c5c598294f7a136929d8dcea1c187656342cae01d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b538547f8f353523ecd0f14e8741a886b614923904e923805c08fc970752bc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f41829165e9bff9b75ba0d4e9d7ca576fd072c4dae92f73abc628af80814bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0209739acdd0bf38a3618ab79325d4a13e017e62700f1d9c83a029134f91167a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a84297d88d46d57dcaf3348deeb07cfcd742168fc8a4c1596b387525787ccf"
    sha256 cellar: :any,                 arm64_linux:   "7254284a98578b6bd886ffbb5b4969557564bfa9ca4a0c0b92f98cd24397cc80"
    sha256 cellar: :any,                 x86_64_linux:  "f4b12c9dae570cce10873ffa6bc6091e41905fe025b0196e69f288177664e678"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  resource "grin" do
    url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.1.tar.gz"
    sha256 "841a698986ff05768c6d7cdf2e59d44571533522fbcffdab0a0de01c8de1d4a3"
  end

  def install
    resource("grin").stage buildpath/"grin"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end
