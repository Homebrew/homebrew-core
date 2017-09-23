class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.3.tar.gz"
  sha256 "9e4fd094080c27f6f419f3fe1fce369621b9469de396e126405153784134da00"

  bottle do
    cellar :any
    sha256 "3f199c08c3ee562ec2ffde6ab1e130a004956e5c3b08a3c977797b46a882716d" => :sierra
    sha256 "4febae463c234004d14143635d955862584b03e0971fefb838eebeb8324d406b" => :el_capitan
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
