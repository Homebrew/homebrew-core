class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.0.3.tar.gz"
  sha256 "c4bc31d7c03f4b6fbe5d3baec83069d704303e478875921bb8e08e7a0edb468d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1e11fe8b10b498cf7658a74f435b0f6c69413725ce1d2c3911dab100b6db7a7b"
    sha256 cellar: :any_skip_relocation, catalina: "1b936d7ad3720895f67decc1e68c75f60be17d1f9e428f0cb68d38fa55bea449"
    sha256 cellar: :any_skip_relocation, mojave:   "d5db0c0384a829c326df7e85b970da1cffeee900c447e132881d9abb6cd5558f"
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
