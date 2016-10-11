class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "http://mp3blaster.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.5/mp3blaster-3.2.5.tar.gz"
  sha256 "129115742c77362cc3508eb7782702cfb44af2463a5453e8d19ea68abccedc29"

  bottle do
    sha256 "7bb86d54a00ebdb133382a31ffa022d819cadbd0d33b074c4f08a92f7814aa06" => :sierra
    sha256 "0891dec8324c89e46dfa22975db73c9e08d6c5d6c21741c48aa2542073dd32da" => :el_capitan
    sha256 "42a28275b2dad976d812cfd93e47fd56c9aacacae16575b7669bf8d3fe0ef153" => :yosemite
    sha256 "aa8d1b1d12b171f77093530807529c57fc510c6f6f29f0bc2b6d4170028acedd" => :mavericks
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
