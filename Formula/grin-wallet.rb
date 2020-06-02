class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v3.1.2.tar.gz"
  sha256 "651b3f6b9be5b0cbf04a4f81d24eef7c5804aa4534600d441671f0144b21311c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d15b6d81f22d8785ae23e1a784c9c9d8e7bb7f7707304cc93ab864642d9bcd19" => :catalina
    sha256 "6272bb8a6a2468743aa4092e5a8c08af926e136dc747c2d0136e235fdf7f70fc" => :mojave
    sha256 "bf9d41682a4f6a0a0ccd5c8affede0d4233d2050627fefd06aeff83c0d213156" => :high_sierra
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
