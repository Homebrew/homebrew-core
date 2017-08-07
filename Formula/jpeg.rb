class Jpeg < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
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
