class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.1.0.tar.gz"
  sha256 "33b3d00c3830c32927f555bf75ddc4d37ef7ee77b9ffda0e5d46162c4ffd0c9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342e42ea8633a8dbffcd034bc4b980a380a20133d4ae8dd864f95aba73ae2a66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fd93430e16fc5d5f856bc53961fd29b2c4817266e7144a5acd75cb06966c151"
    sha256 cellar: :any_skip_relocation, monterey:       "20ea76cec3e1ac989368a14f4add19def5a60a09272f5b03b6d91885215c959f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef761e96659760aba0f64a4218a30a0171baebf1c565b543179b2540a7c06f92"
    sha256 cellar: :any_skip_relocation, catalina:       "5dea056f76f828d2b016d4892481387c2a06820099198e0d91072de3acc29545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e679400d4c63acd8c30e2652f6b7acb2fb5635c278ab9ab43b24716fa46fb833"
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
