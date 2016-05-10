class Dssim < Formula
  desc "RGBA Structural Similarity C implementation (with a Rust API)"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/1.3.2.tar.gz"
  sha256 "2e79f8cf7cb7681f7f3244364662ce4723739745201217d85243bbc709124e63"

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
