class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz"
  sha256 "a5e6a0a9ab69f40f0f59332106532ca76918977a974e7004977a9498e3f11350"
  license "MIT"

  bottle do
    cellar :any
    sha256 "cda21372c1a5a131c1bff0f56db0bcede77fc33b7d7993a2d10c942a687a12fa" => :catalina
    sha256 "73e0789c105bca4c823f90d4e299fa92033a3420efbde58f173cd09a469ad3a2" => :mojave
    sha256 "841ca895ade3760d2ded53aa4734a2919ca1f74cdf8acfb8cc63c9f3aa4d1165" => :high_sierra
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
