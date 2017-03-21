class Guetzli < Formula
  desc "Perceptual JPEG encoder"
  homepage "https://github.com/google/guetzli"
  url "https://github.com/google/guetzli/archive/v1.0.tar.gz"
  sha256 "9766353d4bcfb9ea1c4018770d23a321986cdf1544d0805d14361686d7592c92"

  head "https://github.com/google/guetzli.git"

  bottle do
    cellar :any
    sha256 "d9b1df09bb1aa76e94b0465c990bb7e296a3ee2f32f610aaebc9cb65dec864ca" => :sierra
    sha256 "0becd4f0800be86e7b0bf4aee902e90723d2caba6b9fa72439a6b6314503890d" => :el_capitan
  end

  depends_on "libpng"
  depends_on "gflags"

  # Linker fails with atom not found in symbolIndex on Yosemite
  depends_on :macos => :el_capitan

  resource "test_image" do
    url "https://github.com/google/guetzli/releases/download/v1.0/bees.png"
    sha256 "2c1784bf4efb90c57f00a3ab4898ac8ec4784c60d7a0f70d2ba2c00af910520b"
  end

  def install
    system "make"
    bin.install "bin/Release/guetzli"
  end

  test do
    resource("test_image").stage { system "#{bin}/guetzli", "bees.png", "bees.jpg" }
  end
end
