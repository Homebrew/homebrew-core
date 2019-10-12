class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "https://software.wise-guys.nl/libtextcat/"
  url "https://software.wise-guys.nl/download/libtextcat-2.2.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/libtextcat/libtextcat-2.2.tar.gz/128cfc86ed5953e57fe0f5ae98b62c2e/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9e178bd2a1479fb8d7be57c03b0bad722fbb94221d50b4b807bd6c89126492f2" => :catalina
    sha256 "02d7f744996abfda8bd85b4580c5a92a8bd89ad6cc06e2848caa9b3b0e858144" => :mojave
    sha256 "7997ea512b672f165e1e53e941147e9a520a9ab5d71b8b22e4a71622690e7cdb" => :high_sierra
    sha256 "24fe8791549204d8ef6e596fc327fbd3a645c729b440ba31ef47cf545f6f5b30" => :sierra
    sha256 "afa51f83d0a3c96ffc6f6c35011c864347f31d2c3aea987102c59f0257177072" => :el_capitan
    sha256 "1a63f24b16949843f6a3f6c17d9467208a471cfa6bf1b193738fa94c2d320f02" => :yosemite
    sha256 "e7880fa731747f117a943fd99bd41da25bae3e6440316d782c4798cf3f55e0b7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (include/"libtextcat/").install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
