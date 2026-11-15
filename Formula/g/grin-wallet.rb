class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "a044c594c0492cc96b48e6f32080cfbd4e9154229647ed29f16ef5caed033208"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e01b91580dfec6677f10837ebc8f02c4684fbf7c849c3a1c9c2dabb3a701263"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c6e48938b1c77b6d37745316e794c1984c17b8ecce41809511d99541bc4ff52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d20e01f799e91beb3b67305ccf6c82e169829fb98af5a5af2d72ef2c6fef68e"
    sha256 cellar: :any,                 arm64_linux:       "c72edd8da323d10e186f60a1c53cc86e3038d4716237c93ddcd6660d18a7979c"
    sha256 cellar: :any,                 x86_64_linux:      "fce81743dd97a483c75c3abc138379dbdb589cc42c4483367b35211b442abbeb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  resource "grin" do
    url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.2.tar.gz"
    sha256 "df68a9496db18f6f1e6e286a95ecdc5f3d25de38affe9872c650b4b004c1e2d3"
  end

  deny_network_access!

  def fetch
    resource("grin").stage buildpath/"grin"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end
