class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.8.2.tar.gz"
  sha256 "49f397b5604cf60fe5d453a34568a4fd403750445e3ff5b9ef82138f9b230747"

  bottle do
    cellar :any
    sha256 "e4d7b558b5e7717dcef5b1e4cc9d1b5d3ba9ac66e8978d6de74473d74fdfed66" => :high_sierra
    sha256 "a076d1ee1869b9363e63371688f3c04af1e2db5195fc378e85d05e77ecbb6002" => :sierra
    sha256 "9f59be85d6d94a7487c66a0e97833a44775f878ce96c27f360fd2a689b3591cc" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
