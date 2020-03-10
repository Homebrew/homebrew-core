class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v3.1.1.tar.gz"
  sha256 "0151e7235ca52381ffa30ebe06cdb6841afd48331f68fb477bf7d5b740e03cc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "96ee0762ffd1cced6aeab206bba79ae021c8f5b867e4a28364a0cc9aae332b03" => :catalina
    sha256 "a25c505d77ff7d737f20f3a8a8db9515b787bcd01540a4cbe5b83a805c1f6b26" => :mojave
    sha256 "65aa66d65362a384650b49ef682c673ac75757d40c1d798c50a44ae0cf2549af" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
