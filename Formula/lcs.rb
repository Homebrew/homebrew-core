class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  else
    url "http://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  end
  version "4.07.4b"

  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  bottle do
    sha256 "a8fa614ec5adc3ee2d7417a024bf5e9c78e9f8d4e043e0b916dc5a99f1bb1d9c" => :sierra
    sha256 "621487b12c93a9b37e1330041f979a28d3d310c1d8c9efecf274808d081d510e" => :el_capitan
    sha256 "9ca23650e17e177c4c9fa5352dc81a9f415bc3778b2fd8a55330936eb4d7d28c" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
