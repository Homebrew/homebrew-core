class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/2.8.0.tar.gz"
  sha256 "d9fcabb74fab37cc61a7427782dea02b9af7ca34954e5491c164b62bf7b0316e"

  bottle do
    sha256 "5c95fc8ba2381b98d2e97500159fdafdb37b53e5c60a2eeb501478c3dff6d8bd" => :high_sierra
    sha256 "5ddb367412e124a9e7cab402642e40e7bc1ed267c32ce23a04132bd1586c0cdb" => :sierra
    sha256 "800b61fabe131e7257ddbf651e4361aa7b9ed75829c8e42c52bb1fa55bcceb66" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
