class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.10.tar.gz"
  sha256 "5c1f75c285cd87202226f4de49985dcb75732f527eefba2b3ddd70a8865f2533"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "90066ec2d3ee13cd9dedc78a2665b21ae534a74f23b33937f4ff37d76ac82e91"
    sha256 cellar: :any,                 arm64_big_sur:  "ca3e3ff37f667f3295d4776e11028405fb793a7c5583d61fdd4588215ede0764"
    sha256 cellar: :any,                 monterey:       "b2be123d2e3da48c4abbffe68636381e51dd749b229006835832db70c10fcb82"
    sha256 cellar: :any,                 big_sur:        "356f73aad93c85e5bc5fb118f6cfff6c07ae13a54c30456154135cc3ccdd8ee2"
    sha256 cellar: :any,                 catalina:       "63a44797858280eb984d83586f2579bc57a7efe8d49e14e885368a3c29f73bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5b1df2269ee990e502da52bafae2069c06350d4bc4759c3a9e7266ecb23847"
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
