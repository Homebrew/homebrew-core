class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.0.4.tar.gz"
  sha256 "9cc8bbb4d1aed7a9dc34b67d5253f10844e9ee966f147c0063c28d94d975c24c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b65ab48f15d777244a45fc67e569f3990f6cd8fdd6da60888162218f3b484418"
    sha256 cellar: :any_skip_relocation, catalina: "dc83704a6fbc2410810b61314eecbbd37faadb2a2f068b4b16d7ab42f04d75a9"
    sha256 cellar: :any_skip_relocation, mojave:   "7e174b9bdd34dec0179e1d1ce8bb4f60a4d377e137e64462edd0f7cb0245a3e4"
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
