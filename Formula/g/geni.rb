class Geni < Formula
  desc "Database CLI migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/beta-2.tar.gz"
  version "0.0.1"
  sha256 "8d6300cd75461a98348695d0bdff6084941b3409c9b79031423272185bdbf6bf"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"geni", "--version"
  end
end
