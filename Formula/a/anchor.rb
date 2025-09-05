class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "0c9b1e3e1f14e78cb00271171b1cfac177c7c887814b022196bcbf7e2389e089"
  license "Apache-2.0"

  depends_on "node"
  depends_on "rust"
  depends_on "yarn"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")
  end

  test do
    system "#{bin}/anchor", "init", "test_project"
    assert_predicate testpath/"test_project/Cargo.toml", :exist?
    assert_predicate testpath/"test_project/Anchor.toml", :exist?
  end
end
