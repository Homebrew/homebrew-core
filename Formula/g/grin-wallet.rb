class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "433bd59512e2b2bf598682f5fcb2d89c2c97c729b58def8c0bb720c31738c264"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bc010d504d0ac7b43ffe2cddb361259a560345dbd71f1917934d9e802f0bf41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9851105e1cd32ade5a0eeaaa87859976cfb4b89595637f4554e482c96ae88db9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b72a2de234878c98b25390c79019c98383676cd0ad184cc902d33e110412a91f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f230c6239a8c23b6def966b7f000b87685b1b9e3663b2f555b3512344fc4d4bc"
    sha256 cellar: :any_skip_relocation, ventura:        "22c1d1ee5029840bea97990ee692a158864bf9f38648bfd2d66b3edde7d977f8"
    sha256 cellar: :any_skip_relocation, monterey:       "1b7a2ca6da85563012317ed1286580dd112114170bbceb333f170f1883f58575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1876d013e472222e9d9ae333ded6e740610d67b67b9fe3185e3ec523c8b34dc0"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
