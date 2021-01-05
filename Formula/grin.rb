class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.0.0.tar.gz"
  sha256 "07827583690d131918423265eb80dd1c720997d9d58c7ce2eeb12541ee66387d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b43b1b070c857ae446c496fc837634624b3199128b3a7212ac8541f77bf70a6e" => :big_sur
    sha256 "e92f7bf7c98330543de4939bbc2d506f109cebdfd406f356ed408720d6f7292d" => :catalina
    sha256 "55f22d3460a12a3167c71ba7f450b64e2e81afcc72f6f3408b9a55b9284ceb16" => :mojave
    sha256 "c1f7a7170fe91c4b8fd1b7a7da6de551c01bdd610e4325344dfbbe2398f94830" => :high_sierra
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
