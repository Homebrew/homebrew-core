class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "48541d3aa6339b9c158c79d6024ba93ae68ce7ae26acbde11c6f82c71375b2fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "652b8dcc00761c20d9cd89ea9744458c4f54265411db5e7aac6954f698b70530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7376e1fea833a1a8104ce94ea6732bbf5e231f20032ae2cba86395d430f8a800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8af153afa4b5008b38fc7a094c48722bab890e8ef88725b9ed3dc8e9be213a27"
    sha256 cellar: :any_skip_relocation, sonoma:         "66dfe12962df1d1750dd68f3ded18cf7ed0171874cddc7a3b5b1105910f96778"
    sha256 cellar: :any_skip_relocation, ventura:        "992018083f136ced75aaec7f93950494cef842ec0eaea0d207b4a6e09007a505"
    sha256 cellar: :any_skip_relocation, monterey:       "616c86c6d60fcff61bbf1c2bf9f93d6fb89923ea975f664ef21364e9a15de46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafd9ccbcb1f10d93fa3fee56d9bcc114c004436f5ed85970d7f7e1cb0b7b3ea"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
