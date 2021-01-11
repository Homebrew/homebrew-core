class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.0.2.tar.gz"
  sha256 "3941a569470fb521ee3b7c3092de4e8d3f85ce6723677cfa5212accbff4d9951"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f7fbf52bf6566297a65088ea0845c520bad7ce0667f5ddc966a1802b85aee4a" => :big_sur
    sha256 "e475add9d1d8c043852bd48d291109dbdd0579be6c2899004b000bc621d6acf7" => :catalina
    sha256 "1f43d5936ee19a839f181d7b1ad8a101f2773fb3f27fd9afb0d3dc337bc2d7f8" => :mojave
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
