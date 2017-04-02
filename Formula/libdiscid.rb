class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz"
  sha256 "aceb2bd1a8d15d69b2962dec7c51983af32ece318cbbeb1c43c39802922f6dd5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c6560b587cc04d4bef36878a8f1f77f8bc870d6caba612170db2bd5a7a7621f7" => :sierra
    sha256 "392984622c1f695d018cb6e79f3a6f4a7b66db8fc96c225631477b000a226ba2" => :el_capitan
    sha256 "8fb4093273d7b74311c16574a8fe8979dad11b81e25e4ae261cd429e1078d873" => :yosemite
    sha256 "1a812cec01d686ebceaabf3548715c767158a88e7ae245a9d44d14e2d632eab8" => :mavericks
    sha256 "c6a182d34a50257902bf122b7cd48f4e5bab32dbf03a1d59c7769330d9eec7e5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
