class Dssim < Formula
  desc "RGBA Structural Similarity C implementation (with a Rust API)"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/1.3.2.tar.gz"
  sha256 "2e79f8cf7cb7681f7f3244364662ce4723739745201217d85243bbc709124e63"

  bottle do
    cellar :any
    sha256 "140f682a13b7fc63fa094dde9df6088a377e8317d30e0f208ffb0513e2baed26" => :sierra
    sha256 "46ff2909894a5d0ec443a84e16b87e6fe746bd53c816091002dde0da15581222" => :el_capitan
    sha256 "b5e6df645abb73ab9b1227d87039397f6acc56c63f422bebc13d7e29a0c9d56f" => :yosemite
    sha256 "51756e74240d03c87a79ff0e14e494d249701d4069ea336b529b47a179c469d3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make"
    bin.install "bin/dssim"
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
