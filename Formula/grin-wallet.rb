class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.0.1.tar.gz"
  sha256 "19102b3a33e8fb19f990eecf999ee11d880d5e0ee8576a42f751d0a1f761885d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "05e8a1345c2dcda04d4d51a0632e88f11b379c7978cc8df558e4f586e8810d95" => :big_sur
    sha256 "99c3c710cca324b279b9f53db6687c5f35dceb1a7fab99e6da08734f1f14fb64" => :catalina
    sha256 "9527840eae34a19dc485a2f13fe0d0422429f08e2352267a637a41b5bf31bf1d" => :mojave
    sha256 "c9f755928079e4d3073e5f80071b2d7a860b3f0daaf44abd0e0d5c1c1c106cab" => :high_sierra
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
