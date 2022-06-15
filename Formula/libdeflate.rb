class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.12.tar.gz"
  sha256 "ba89fb167a5ab6bbdfa6ee3b1a71636e8140fa8471cce8a311697584948e4d06"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8d921576fe13e8c72327b14701a7db6db27654bc837d7faf0a46ce19b32ba15"
    sha256 cellar: :any,                 arm64_big_sur:  "fe80e93d1d0010bbbf00cb881ae6ece58987840880cbef0ed570bdad2329a436"
    sha256 cellar: :any,                 monterey:       "1d2a45ad39ef09f59d67ccee89b25a5bec78448ef93afe047e80af7f61d04300"
    sha256 cellar: :any,                 big_sur:        "2b6ffb1987abd35deb9e8f924da7af6b2fa1dde4defc4687a59da3a28496e140"
    sha256 cellar: :any,                 catalina:       "4615cfae8a578b52054a7a0dbf62ca90493f0ca9883bc2715a52d27371be052c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffaccfc47fc5a767ab19d370bc3fd832c96281dc1b46d7a7d31bec9917ba034"
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
