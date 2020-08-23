class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gz"
  sha256 "60748f3f7b22dae846bc489b22a4f1b75eab052bf403dd8e16c8279f16f5171e"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "cda21372c1a5a131c1bff0f56db0bcede77fc33b7d7993a2d10c942a687a12fa" => :catalina
    sha256 "73e0789c105bca4c823f90d4e299fa92033a3420efbde58f173cd09a469ad3a2" => :mojave
    sha256 "841ca895ade3760d2ded53aa4734a2919ca1f74cdf8acfb8cc63c9f3aa4d1165" => :high_sierra
  end

  # Install shared lib symlink as dylib on macOS
  # https://github.com/ebiggers/libdeflate/pull/74
  patch do
    url "https://github.com/ebiggers/libdeflate/commit/061282f1c1e22cf9372835ca163bbe1819b892b9.patch?full_index=1"
    sha256 "ed1ccd205f3d070aa2a50755e6c27a530fc8273de09e6d9a4a3ea79d529ccdbe"
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
