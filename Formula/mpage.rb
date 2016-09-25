class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "http://www.mesa.nl/pub/mpage/README"
  url "http://www.mesa.nl/pub/mpage/mpage-2.5.6.tgz"
  sha256 "4fe66dfc27f7c4bfbca60ef617f968aa2e6ee877e8921aa968c16a03aa4edc04"

  bottle do
    sha256 "ba7d78cb7b683a88c1ee418d62e19669d52caec81bd338f5b8b42f5b9d8a4f98" => :sierra
    sha256 "48a2c82f44b9e241edc1ed4727e4b788da8f7dc48a28d0cc8f9344bec63ae757" => :el_capitan
    sha256 "66815ec14edcec106911ae720b21bd5220b8791592a578c26fe4a23a74fd38ea" => :yosemite
    sha256 "9016175184826209a098bc8a2e5c73949879bc68abd67497151f714e6922e0b6" => :mavericks
  end

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
