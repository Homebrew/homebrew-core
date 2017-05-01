class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "http://www.nongnu.org/lzip/lzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzip-1.19.tar.gz"
  sha256 "ffadc4f56be1bc0d3ae155ec4527bd003133bdc703a753b2cc683f610e646ba9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d44d4a51d26d920613b90d057200ad25c6d717d6d4b462b30b9125616d9819d" => :sierra
    sha256 "dcebc83e260a8bfdfe55a2cc991a4184d935b6fe53390160d7e2154371671845" => :el_capitan
    sha256 "a5e4b8f48d93f2d3ca8988df55b619ff779ff5331d3ee64dd31b57b7d88959db" => :yosemite
    sha256 "cfde4d3e188c4347a23811e2712a60bd646a3037e6f7b9cf6afecd6db933fda0" => :mavericks
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
    assert !path.exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
