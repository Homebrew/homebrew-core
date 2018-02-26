class Jpeg < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9c.tar.gz"
  sha256 "1f3a3f610f57e88ff3f1f9db530c605f3949ee6e78002552e324d493cf086ad4"

  bottle do
    cellar :any
    sha256 "06fdebbd4693b6a25850fb885f8e8c9fd2389a5d0a1b78008d569cc04c441272" => :high_sierra
    sha256 "658fd93026eafbaf3d3a8c2db53aa8ffd0097837ac8f500477b2352433d81723" => :sierra
    sha256 "e22ae898671f312ed0a2d0eab8bf6a280e3f709642789c7932d30fc0e93cfb22" => :el_capitan
    sha256 "306863ccbb13b68787378b55a717784c214209496ac70d761f92ab03e52c03d0" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
