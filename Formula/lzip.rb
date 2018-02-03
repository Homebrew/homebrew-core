class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download.savannah.gnu.org/releases/lzip/lzip-1.19.tar.gz"
  sha256 "ffadc4f56be1bc0d3ae155ec4527bd003133bdc703a753b2cc683f610e646ba9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7139dcfd0b8611bbc6c6e855cc678883dc0340214a4af84d55bba27f2b54461c" => :high_sierra
    sha256 "0a6d59b6f75c039ad566dbda99ab47f929f5087f0b551c2930dab208b67ec9d0" => :sierra
    sha256 "46fe2fe457326ea5f5bff7252b1e73642e3a516ee3f97e343cd03a253372047c" => :el_capitan
    sha256 "9daceb61b21e2e493683348ebd0f3770a4085c8d75c2d2f7b6bb8ae455087383" => :yosemite
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
