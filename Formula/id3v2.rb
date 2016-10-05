class Id3v2 < Formula
  desc "ID3v2 editing tool"
  homepage "http://id3v2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz"
  sha256 "8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf"

  bottle do
    cellar :any
    sha256 "3b1d75af49217a58f5ecb6f0e9e34564b299903898c76145218a6496de3a7778" => :sierra
    sha256 "941e267b5a214013c8085c7918c0d8c1805c906cacf162191b764d2ae1df265f" => :el_capitan
    sha256 "cd8dd2f943081a051214bf0eedb3c1431abf2bb060a528058e6b9d4c841995ce" => :yosemite
    sha256 "129381e13539c589fce554a305f4c0a83763ae01865f8810c4145089969c51db" => :mavericks
  end

  depends_on "id3lib"

  def install
    # tarball includes a prebuilt Linux binary, which will get installed
    # by `make install` if `make clean` isn't run first
    system "make", "clean"
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end
end
