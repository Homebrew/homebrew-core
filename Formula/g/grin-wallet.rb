class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "648948d74a001fbdb377184ec650941056f723aad12ea6fca2efe4b7b4b6006c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fddb6447f27df38fe658e8bb2e1e37b1fbab1a64a58d943ea16a8cec7c71838a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4396c658f6c1f97ccbb8b884e1294a03a69b08affe81fbd204743d66c670a04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe66c6e897a6a5863cf3c1ec9f4b6427c5aa9443447992f3e86f57a4abefedd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4aabd39cab1ad4a19e915460830052b053e09f0097499c1585c623429de6ad"
    sha256 cellar: :any,                 arm64_linux:   "ad3e4ad3ac4779494d7f145085568fd4ee50f85ead0565c2f2a7a08c40602bce"
    sha256 cellar: :any,                 x86_64_linux:  "739ff19be08d6cd86c9764082bc1ac9a05e81f891079e66c7347f2b66c4a54ca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end
