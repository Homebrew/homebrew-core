class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.1.0.tar.gz"
  sha256 "8c8bad23e32fc45bf8bce484c46bd5d782f9bd13ff7d442e316e5140fea1ed72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c8fedce6fb2014c390914a9c16ab8c42ef06d34b0e7cf8278ce5ffbbc3a36a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf2f070ac6aea3f7ca867167068684b0279c4f9ed13b02e328e88e5c94fa6f6b"
    sha256 cellar: :any_skip_relocation, catalina:      "aa5d88ba12bae1e7e468d6bfc165b1c105790e391e26493a22d7500c3d13dee5"
    sha256 cellar: :any_skip_relocation, mojave:        "94e2c97fc9dc4b3f3e1ebb47d1505484052e567d8a04b1bd082c828bce448014"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
