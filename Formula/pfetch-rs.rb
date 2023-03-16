class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ad04f151342b9f3d5764c4a9d47844d7818a0fc00bc2d39288ac27fca5be8738"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
