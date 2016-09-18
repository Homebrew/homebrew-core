class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "http://www.mesa.nl/pub/mpage/README"
  url "http://www.mesa.nl/pub/mpage/mpage-2.5.6.tgz"
  sha256 "4fe66dfc27f7c4bfbca60ef617f968aa2e6ee877e8921aa968c16a03aa4edc04"

  def install
    args = %W[
      MANDIR=#{man1}
      PREFIX=#{prefix}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    (testpath/"input.txt").write("Input text")
    system bin/"mpage", "input.txt"
  end
end
