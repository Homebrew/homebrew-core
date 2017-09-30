class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.5.tar.gz"
  sha256 "ba7364ba8ff9256abb8aa4af8736f27d0b7eaab51c14ff828cc86aabff33ec65"

  bottle do
    cellar :any
    sha256 "7314a066ec160768b90fa17ad18a5a85cbe19294d5c5a0cb103bc49a9a9f13c4" => :high_sierra
    sha256 "7d04fe39246fe453bc1962a5608e8a5b680380ed538becc8284b4fc2dc78277d" => :sierra
    sha256 "950de8c20365e5486ba0168c9ca9bf8e6c3fba842d6c88fcd6b48930d463578b" => :el_capitan
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
