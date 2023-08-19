class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.8.2.tar.gz"
  sha256 "a34299335653a83ed9c23b7e1f0648037aad58a6dd1efd7ae5413ae99b49182d"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "064beeb4c7c5556dfa697ae269d703b65042c2e3f65fae12c4b016b26ae11d87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a4de01378820a86cfca5e5a0e89566ac46df14f440216c5ecbdb77c2aafe4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ba6b02a78d5d5903b6a26433953b8af22612ab56bc6637885afb4a596565e8"
    sha256 cellar: :any_skip_relocation, ventura:        "2367c1ddbd5a676b6e11f00cbb32aa29907384b3ee792804ec706a316747053e"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2dc494d88f1f463f41da06b28f48d404872063919f8cc6d7c8e4361f405849"
    sha256 cellar: :any_skip_relocation, big_sur:        "02d857d3137c4df901e0e25eec5c52e1343f1b4c2566b1594580ce7a2185ae95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee3d12fe7fbac3a568e301680965d7ba350b448a2728b0e5f2b7eb3d3f5e62c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
