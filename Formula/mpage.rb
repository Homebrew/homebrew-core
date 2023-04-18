class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "https://mesa.nl/pub/mpage/README"
  url "https://mesa.nl/pub/mpage/mpage-2.5.7.tgz"
  sha256 "51ab9c4e5fdd37e03c90df6756f30c0b61a34f066cb625f8924feedc4b3ec3fe"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "cd01e6be613230f334dc99b55c4dfa89a2007261233079513a91f762b6274604"
    sha256 arm64_monterey: "6a83b49a225ea3e7c45f06bcb70fc7c822b07aa80a23f51667e74d1264f6ef03"
    sha256 arm64_big_sur:  "35ecb743e454140d1a0651cf435d5658a295cf7c97940635c71c644fdbe59646"
    sha256 ventura:        "31b73fe1d79c5ac5904a3a8248a9471da356b0552fd032f1f445768301283edc"
    sha256 monterey:       "3df1930d88318f57b843ec99a1f7a7cfe111dd6a5d3f0042b044277fcfd54819"
    sha256 big_sur:        "36572d6c594d5c257a136d19ce3c39be76dc7c81d5757817cd78992c81e0efbc"
    sha256 catalina:       "4b21863fb89e5381c2d4c3ad496809014479b961c3885dbe09ee55434382db6f"
    sha256 mojave:         "aba18c308b7607332d0e3d9ab0f02fd44b1bdf1f9a4dbd4baee828261172fc2e"
    sha256 high_sierra:    "fb22af4c695ec3b6e27980a8b180bf4a7904b81ce5ff51f46f0d5ccdc5da8d07"
    sha256 sierra:         "2d020c69ee688a3a2d82f5f2c531a9f7abaf3923f0024e3b5eb2f1466992d7c1"
    sha256 el_capitan:     "4b899cd8a7280c7317513a51f6b3227f88c6324c39712530341b9d108d829ee5"
    sha256 x86_64_linux:   "d5e29f0b48f8fc99ce3f047abeb39bc95d4b316257b328b092d04191fb8bcfcc"
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
