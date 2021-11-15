class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.8.tar.gz"
  sha256 "50711ad4e9d3862f8dfb11b97eb53631a86ee3ce49c0e68ec2b6d059a9662f61"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "753a9e821ec87092fd731b04b073937a126a41776eeb638c1d7858c448575e99"
    sha256 cellar: :any,                 arm64_big_sur:  "663669870ff0bde818c9d35e24d6dbb4c0601d61b81576e34e18931b1f4badfe"
    sha256 cellar: :any,                 monterey:       "885468709de7f330635973aba560e918fd50c73321f652d060e4ecc828789782"
    sha256 cellar: :any,                 big_sur:        "c984576da43b8e60e2f263cbdc13c176a42958b1c1e168ca8bd49505042b67d0"
    sha256 cellar: :any,                 catalina:       "083f6b73565408c7a3fb01d92dd917364ab0345125741d8e811963ff74949ade"
    sha256 cellar: :any,                 mojave:         "7c9e2f9ef003ee75d5639b04ca25b7abe97d3d7548bf9f1d60b13e7071cbf1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b307828767aa51938d7f552e7c6ba69473338907bce68e6cf561e9302a1c36e"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
