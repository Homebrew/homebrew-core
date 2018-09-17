class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.20.tar.gz"
  sha256 "6c0d87c94ab9915e76ecd313baec08dedf3bd56de83743d9aa923a081935d2f5"

  bottle do
    cellar :any
    sha256 "46c2a814cc94fabee65422d8ebb223fca48858fc8d2eb46541e8e05f4a6dd636" => :mojave
    sha256 "a01433286fbf7f0e1b5287af5aad39878d10f4375656d9477c9f23e4ed2d2077" => :high_sierra
    sha256 "d6ed7a2c17bce7c8d6e96530ebe7cfabbf814e701c301d824b11ea22cd46d7d0" => :sierra
    sha256 "782f20517ff7f10a76a5969eb698c9fd9fc279459c56cfb90dda81c30ec5b5ce" => :el_capitan
    sha256 "07bfd3dd2f19032d05d2415642569df0ec8a74f48f545b3e5e1a8548849e9b42" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
