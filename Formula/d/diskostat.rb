class Diskostat < Formula
  desc "The best utility to make some space"
  homepage "https://github.com/Diskostat/diskostat"
  url "https://github.com/Diskostat/diskostat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7a535cecdee4157e5292d251741048b186cce5a7b7848ec03ddbd8e5bdbd3633"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "false"
  end
end
