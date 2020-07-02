class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v4.0.0.tar.gz"
  sha256 "b31e7e0271c7c821c66153fbc2b70aa7db365309a5460fde9dc004a5dcc72986"

  bottle do
    cellar :any_skip_relocation
    sha256 "ede3e5a86cd979b95be435fa72c976c06572e4aa31ca87d901bffb30f81e944b" => :catalina
    sha256 "470f5394c7910bbd60c2698f094cc065cefa62a130af4ff9793bdfdaa6718515" => :mojave
    sha256 "98670476e9de66f97b5bd678964f32b21eaf1361d404d3d2bf0685202917d1de" => :high_sierra
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
