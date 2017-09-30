class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.5.tar.gz"
  sha256 "ba7364ba8ff9256abb8aa4af8736f27d0b7eaab51c14ff828cc86aabff33ec65"

  bottle do
    cellar :any
    sha256 "56c848aeaea35d03a9c7a3fc32ccd0a10135bb18c2575480b398c6c97e586fda" => :high_sierra
    sha256 "3245bfe9f53733c704631a49e46fc5db472e1545c3475a6747dc4f230af81d78" => :sierra
    sha256 "435a26c7bb14b2f370bbde3b3535354df1cb5890b07a9a59abedd5353d106444" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
