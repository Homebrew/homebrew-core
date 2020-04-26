class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v3.1.1.tar.gz"
  sha256 "0151e7235ca52381ffa30ebe06cdb6841afd48331f68fb477bf7d5b740e03cc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "76459e3d2e8254a95149cb700a027e871a5e3c840f40e2ec0b070360b576df63" => :catalina
    sha256 "0f76a01e6a06fd848d6298c8b748b9822107da1f64ce60c6423f1318f8c4de72" => :mojave
    sha256 "a3da4046c64fe6d0b7be1e7c9fc048cc4d2d375455e53e39a04f56d2641e66b6" => :high_sierra
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
