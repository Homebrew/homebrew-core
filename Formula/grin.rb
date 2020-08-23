class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v4.0.2.tar.gz"
  sha256 "398f5ecdd80266227494e515e214218861c7dc597c0973e337b9f5ef050d7345"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "21a6189271d6a92aab6103f9e48f5ca4e4aaad9e2bb6f3c1fbe042ba84dee292" => :catalina
    sha256 "f88f2da4ab778f5b1488fa55599418863c312d3847303f736265b9478e81657b" => :mojave
    sha256 "a2779bb17742ddb0a1706fb48202c677a8d5c6a2f8da941c9cff43a0e71534be" => :high_sierra
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
