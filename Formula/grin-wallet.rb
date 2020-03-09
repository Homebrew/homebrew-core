class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v3.1.0.tar.gz"
  sha256 "acbcb5b052007bbd8d6028cf409379d94bf5ed5e451f903f97c677a67f2986db"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac32e41a85ffacf929820c3970c04ce4d168dfda8896e2bf2552657d9b557c39" => :catalina
    sha256 "ed83fb73f593f056bfce91b2bde5652950153dccc5ceb7a497e8621b618988ce" => :mojave
    sha256 "b15137f4a5f3aef44d5f7440fa430dd724715e7684164a82e36f2599c7b43f67" => :high_sierra
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
