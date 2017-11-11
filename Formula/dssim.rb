class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/2.8.0.tar.gz"
  sha256 "d9fcabb74fab37cc61a7427782dea02b9af7ca34954e5491c164b62bf7b0316e"

  bottle do
    cellar :any
    sha256 "f1eb2a6f9a2dabe6613943d12255017c6af64c7adcfc24f882c772d477de605c" => :high_sierra
    sha256 "140f682a13b7fc63fa094dde9df6088a377e8317d30e0f208ffb0513e2baed26" => :sierra
    sha256 "46ff2909894a5d0ec443a84e16b87e6fe746bd53c816091002dde0da15581222" => :el_capitan
    sha256 "b5e6df645abb73ab9b1227d87039397f6acc56c63f422bebc13d7e29a0c9d56f" => :yosemite
    sha256 "51756e74240d03c87a79ff0e14e494d249701d4069ea336b529b47a179c469d3" => :mavericks
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
