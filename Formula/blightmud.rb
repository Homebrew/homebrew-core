class Blightmud < Formula
  desc "Terminal mud client written in Rust"
  homepage "https://github.com/LiquidityC/Blightmud"
  url "https://github.com/LiquidityC/Blightmud/archive/v1.0.0.tar.gz"
  sha256 "76ce6df25dfff1d7d7c5c5027e260e9a0209d1475347b7a036e34047af493760"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"blightmud", "-h"
  end
end
