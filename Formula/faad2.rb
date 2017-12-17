class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.8.tar.gz"
  sha256 "985c3fadb9789d2815e50f4ff714511c79c2710ac27a4aaaf5c0c2662141426d"

  bottle do
    cellar :any
    sha256 "ca4c735b958cc393e8ccfa90ca3b0c372febc7175c7be3070aee64fded14d593" => :high_sierra
    sha256 "b543a97001b82b54a7b650be495394d73b3c81822ca989e154380630ce503ccb" => :sierra
    sha256 "6dacb8f2ebff6a348a0b1be0a8bbec37a4cee81a28dad9fe2fa2f809461e9e89" => :el_capitan
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
