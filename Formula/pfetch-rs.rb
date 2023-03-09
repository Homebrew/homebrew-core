class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/gobidev/pfetch-rs"
  url "https://github.com/gobidev/pfetch-rs/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b21a91a9536ca776c38541e3d79a6c8fab4b522db0ef15353cb11e0833e7d3f7"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch-rs")
  end
end
