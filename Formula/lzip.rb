class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.20.tar.gz"
  sha256 "c93b81a5a7788ef5812423d311345ba5d3bd4f5ebf1f693911e3a13553c1290c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c43e2df881d99817f8769e144703f4fd297a2fe6a561f6d27c1db3f0bbbbdea5" => :mojave
    sha256 "f854fdd0c02100534ebeeba5f120a40524b3e5048665fadb0b2e30519310dbb7" => :high_sierra
    sha256 "8fd74d6652d03e9d5af035e0948e6835f38fd6ca45758c0392f825f232e4b4c6" => :sierra
    sha256 "1b61136446eba909e98195b10340174e3aba0c28264336242408a1c61f4cca90" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
