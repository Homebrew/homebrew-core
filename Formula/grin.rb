class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.1.2.tar.gz"
  sha256 "a4856335d88630e742b75e877f1217d7c9180b89f030d2e1d1c780c0f8cc475c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccbb426ce7d3830eca71f3b82cc20fbfbfd05b96716ce24e4b805700310adc23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "151ca3ab278be9cb9d7a10b2c4cc5c5a0105a3a1624b688a10decba5d35ccadd"
    sha256 cellar: :any_skip_relocation, monterey:       "93e0600ef02de4d29f87b918a013e447642c8a9611f88003a7f716876c2af8b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "73575795db90d1014d77b9305d72eef7ea75b79a197f1add5253d93c9f4458eb"
    sha256 cellar: :any_skip_relocation, catalina:       "724f041a16b20c09efc90ae96f37f03f221253bf2fa1c27dbbf8e1f086831421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6abb67fa62bc612ebc6ba360aebaf5acaf2432b858c60d5556db50420eecc67"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
