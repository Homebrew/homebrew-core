class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.0.3.tar.gz"
  sha256 "943eed3d7b5d54298af7de3bfd6a746273dcfc0909f0efc191b4916e80f1ecf3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "69fd3a511e774117691e4ee7d92ad7f0cdd1ed4851a122f151f741256f88cad4" => :big_sur
    sha256 "0687a7a9cf89ed4d223b1127c2dcf13399d3f57fab8dd3188c018342ebba5ba8" => :catalina
    sha256 "601caa6b27e64383768d615043a9db2623b82f1de1bbce85a41c512caae5f579" => :mojave
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
