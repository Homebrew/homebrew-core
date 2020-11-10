class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.4.tar.gz"
  sha256 "8a968a8b9f605746dfeaf1083a0c6a2a3c68e7d8d62f43bb6a6cd58e9a3d260e"
  license "AGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "b7278a9ef66ad5d2e0b4a57891894818d6642d55ebe7d7f99112a08928817f59" => :catalina
    sha256 "fd33e8576d6576fba097c71a57f938442180e0324cdd0b6134de3dbe0eb54173" => :mojave
    sha256 "8144380182c06069e9aadf524ac9573c0bf3e4ea69571bb9c3b385c86b3ad5a5" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", "--features=video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
