class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.7.tar.gz"
  sha256 "b898fcf55e7b52f964ee62d077f56fe9b3b35650e228f006fbef4ce903b4d731"

  bottle do
    cellar :any
    sha256 "2d57f0cd1c775e6fdf846bfcce8ccd80c41075fd10b57a3fbdca71c1ab2111be" => :high_sierra
    sha256 "95ea002facf23eddefa87cdfa4c8d98cee8beb268802b6c20c1333b6141ebe0c" => :sierra
    sha256 "881372bf82be152b0c72a029f89af750490202faa83d734cb0651b2a23bdc8c4" => :el_capitan
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
