class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v4.0.0.tar.gz"
  sha256 "b31e7e0271c7c821c66153fbc2b70aa7db365309a5460fde9dc004a5dcc72986"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
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
