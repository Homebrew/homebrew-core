class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/sourceforge/lame/lame-3.100.tar.gz"
  sha256 "ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e"

  bottle do
    cellar :any
    sha256 "9e65c67b83efa5a686aea0506dc44935cd2af2d4fe55fe38dc19610a0ccd80dd" => :high_sierra
    sha256 "c2d7bce53be2efb5d19d99ea00fbe69613885cce46009e8ab6099f8d5925c3ba" => :sierra
    sha256 "73c4d677b4e5357dc5baf30c96ac5f33cf7902e9c77869834b7cd9d17f3415bc" => :el_capitan
  end

  def install
    # Fix undefined symbol error _lame_init_old
    # https://sourceforge.net/p/lame/mailman/message/36081038/
    inreplace "include/libmp3lame.sym", "lame_init_old\n", ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system "#{bin}/lame", "--genre-list", test_fixtures("test.mp3")
  end
end
