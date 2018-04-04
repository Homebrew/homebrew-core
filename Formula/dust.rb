class Dust < Formula
  desc "More intuitive version of du in rust. Similar to ncdu"
  homepage "https://github.com/bootandy/dust/"
  url "https://github.com/bootandy/dust/archive/v0.2.1.tar.gz"
  sha256 "ea597ad1fa36b1e05fc74b0b98d89e53e79f9d420959de8eadb0e8d05587e265"
  head "https://github.com/bootandy/dust.git"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/dust"
  end

  test do
    system "#{bin}/dust"
  end
end
