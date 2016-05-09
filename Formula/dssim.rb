class Dssim < Formula
  desc "RGBA Structural Similarity C implementation (with a Rust API)"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/1.3.2.zip"
  sha256 "393a5431f08c747ac19b00176f2b710010d87215aa6f5105e65e9fa7afed63be"

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make"
    bin.install Dir["bin/dssim"]
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
