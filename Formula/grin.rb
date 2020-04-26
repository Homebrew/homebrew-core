class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v3.1.1.tar.gz"
  sha256 "2664af92b1752225ec66656bac4052aad8a8d4ff26cadeb15606ec5f00f9ed97"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3ec3abac01516abb1d4660f6acf7b4dcf47bd223d8f287d62f39e322f1defef" => :catalina
    sha256 "f4a0fae541bf677b2e2dd9fd431855ee7855816677be44d6155c6c6822bb0281" => :mojave
    sha256 "cba0fed4f35a80bbc1d9de9c9efe2aa549f8b3eb5b018826e70965f9a3bf3a63" => :high_sierra
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
