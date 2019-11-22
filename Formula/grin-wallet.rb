class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v2.1.0.tar.gz"
  sha256 "649664af929fc2afd42e52597ad675d3e1856c95e0cda60ef8d4c478abe5c01c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5950dd43be19901a8ae137e204832e9038aface9f754ed4aca0ed7cab156855" => :catalina
    sha256 "6f0cd0a1488d3f7338fe20e1b8d8fb99ca1232f10e1fa645449660b553ca24d4" => :mojave
    sha256 "219e61b427f9709edbdf4195354300da91bf4b162e8ae37ac19e78d1cf8de3fa" => :high_sierra
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
