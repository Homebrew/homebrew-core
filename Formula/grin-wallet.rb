class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.1.0.tar.gz"
  sha256 "33b3d00c3830c32927f555bf75ddc4d37ef7ee77b9ffda0e5d46162c4ffd0c9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "1720cdcdb2a585aa588e3d20eafe0bde5924e844b14bc59fdbddeccdc8f42ec8"
    sha256 cellar: :any_skip_relocation, big_sur:      "a0dfda70b5c6cf1ed883e5af6b61c01aea7ddf18f6f22038aab71e06b5b9801a"
    sha256 cellar: :any_skip_relocation, catalina:     "4b43f745f1b82d9390cdaf4055c9d65e6bea850fe9ad7ebd2818789c33c45dbc"
    sha256 cellar: :any_skip_relocation, mojave:       "3ce2c42866c3d02c527fac13c2393af01eabb9c9591ef25d5503aca073863f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c92e3242b540c4d6929d9ba81d8e3055db6e328d4f6977e388852692ca7273b1"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang" if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
