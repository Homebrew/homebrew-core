class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "0c9b1e3e1f14e78cb00271171b1cfac177c7c887814b022196bcbf7e2389e089"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
