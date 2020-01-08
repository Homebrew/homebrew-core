class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "https://mesa.nl/pub/mpage/README"
  url "https://mesa.nl/pub/mpage/mpage-2.5.7.tgz"
  sha256 "51ab9c4e5fdd37e03c90df6756f30c0b61a34f066cb625f8924feedc4b3ec3fe"

  bottle do
    sha256 "4b21863fb89e5381c2d4c3ad496809014479b961c3885dbe09ee55434382db6f" => :catalina
    sha256 "aba18c308b7607332d0e3d9ab0f02fd44b1bdf1f9a4dbd4baee828261172fc2e" => :mojave
    sha256 "fb22af4c695ec3b6e27980a8b180bf4a7904b81ce5ff51f46f0d5ccdc5da8d07" => :high_sierra
    sha256 "2d020c69ee688a3a2d82f5f2c531a9f7abaf3923f0024e3b5eb2f1466992d7c1" => :sierra
    sha256 "4b899cd8a7280c7317513a51f6b3227f88c6324c39712530341b9d108d829ee5" => :el_capitan
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
