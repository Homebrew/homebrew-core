class Camellia < Formula
  desc "Image Processing & Computer Vision library written in C"
  homepage "http://camellia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz"
  sha256 "a3192c350f7124d25f31c43aa17e23d9fa6c886f80459cba15b6257646b2f3d2"

  bottle do
    cellar :any
    sha256 "b4783ca8cf782a63d09daa1ff363c2fb4c4ea6dd4e75b8beb29167f536227730" => :sierra
    sha256 "a80b2f52fd6811c5c4017bceac418d241c30342c93c1e9ae8911ed5274630e9c" => :el_capitan
    sha256 "94196d40772f262cedb88f3dcf8b66c84fcc78cd419b439bd9619c25d602c8b1" => :yosemite
    sha256 "73db73665d4a3972bc5c0b6250d3bc050de83e54330c88e9282b970bf5ececce" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
