class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v4.0.2.tar.gz"
  sha256 "398f5ecdd80266227494e515e214218861c7dc597c0973e337b9f5ef050d7345"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b3e134dfa20a8dbddbe1496bd8221238c7fe015f5fbcf0db80d3e259fd7e790" => :catalina
    sha256 "74e40158fdec8acea3c99de5c23a6144719f6f6908922f1e70943b9d8ff1887d" => :mojave
    sha256 "d75d99d22e78b8ef484ef6dde9982edd09c88fa906cc7777fc17f510acdcba47" => :high_sierra
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
