class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.0.4.tar.gz"
  sha256 "9cc8bbb4d1aed7a9dc34b67d5253f10844e9ee966f147c0063c28d94d975c24c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "eafd0bb9f9c719e9dbee669fe661730698f9e0cfac50020226167a9a67c53bb6"
    sha256 cellar: :any_skip_relocation, catalina: "0025eaac2de30280dd6ce101d60bdc248cb139acebeeba334f31edc0ba952080"
    sha256 cellar: :any_skip_relocation, mojave:   "51f00cbeaf48f1ba1959a84e7ae962912c590be4263cb5c9ed76fc773adf7040"
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
