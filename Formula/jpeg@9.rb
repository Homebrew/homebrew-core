class JpegAT9 < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  version "9.1"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
    sha256 "0fcac25009100dd809a12c537b9563da2e1244f63a55a33bc2df1376fb80eb82" => :sierra
    sha256 "9bb92308131d09dd0a30601fd12d26538b2006f4c477eac225af51460813958b" => :el_capitan
    sha256 "51c5f9c675dc4a37ebaeeff0689c87d75f960dea1e3e4e7d92bad06795694093" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Builds static and shared libraries.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
