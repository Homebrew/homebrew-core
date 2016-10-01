class Lzop < Formula
  desc "File compressor"
  homepage "https://www.lzop.org/"
  url "https://www.lzop.org/download/lzop-1.03.tar.gz"
  sha256 "c1425b8c77d49f5a679d5a126c90ea6ad99585a55e335a613cae59e909dbb2c9"

  bottle do
    cellar :any
    sha256 "6d0637dd2d12db57881ffdd672ee6fd0ae743fe3f1f14a8175d2047e9d191c60" => :sierra
    sha256 "441a5396549a826b805a181f3b7c6115ee81714acd06978ebf18396ab2fda717" => :el_capitan
    sha256 "8948b68bd5f6ca91371dfbd3522c60015f1010e389ff138e12460bec3ade52b6" => :yosemite
    sha256 "dd86655bbf09a2d39c2b357fd8d19daec04516ed6d9d471e5d7031aed1a64d0d" => :mavericks
    sha256 "0fe2af0dba0474808f9f4979e4db3cd2c1be4df1f2237c75a9a323283c894280" => :mountain_lion
  end

  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"test"
    text = "This is Homebrew"
    path.write text

    system "#{bin}/lzop", "test"
    assert File.exist?("test.lzo")
    rm path

    system "#{bin}/lzop", "-d", "test.lzo"
    assert_equal text, path.read
  end
end
