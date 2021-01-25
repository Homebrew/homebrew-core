class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.0.3.tar.gz"
  sha256 "943eed3d7b5d54298af7de3bfd6a746273dcfc0909f0efc191b4916e80f1ecf3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0dfda70b5c6cf1ed883e5af6b61c01aea7ddf18f6f22038aab71e06b5b9801a" => :big_sur
    sha256 "4b43f745f1b82d9390cdaf4055c9d65e6bea850fe9ad7ebd2818789c33c45dbc" => :catalina
    sha256 "3ce2c42866c3d02c527fac13c2393af01eabb9c9591ef25d5503aca073863f50" => :mojave
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
