class Kakasi < Formula
  desc "Convert Kanji characters to Hiragana, Katakana, or Romaji"
  homepage "http://kakasi.namazu.org/"
  url "http://kakasi.namazu.org/stable/kakasi-2.3.6.tar.gz"
  sha256 "004276fd5619c003f514822d82d14ae83cd45fb9338e0cb56a44974b44961893"

  bottle do
    rebuild 1
    sha256 "e6b0a1d2bc6f7796cce6b66ab84dce9fbca176a9f266e9e1c3784b85c9665f2c" => :catalina
    sha256 "01b3ca16f856fce7cd71cc752b083589f8267ecc3b44bd6b5800cd1a53cb7700" => :mojave
    sha256 "4ac657051323e642a248aaa4cdf7bc464374e0901bf0b87f458e89b0c3233f76" => :high_sierra
    sha256 "a50761a65d9b64f65d81b6045e992dbfb99746815433f7fc187b43bb0aa36f85" => :sierra
    sha256 "7fca04e65ce14fa8d18d19e197525063274057a2760e4841d4e8a9b06f4b0fa3" => :el_capitan
    sha256 "da407c10d807cf72679df6555d29b53f388dd32abf674f1ae0ecbace44fc3372" => :yosemite
    sha256 "86403b2e2a45e2ea81b78bbe7edc7bf2b01d464f351ea265441413e63bf85822" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    hiragana = "\xa4\xa2 \xa4\xab \xa4\xb5"
    romanji = pipe_output("#{bin}/kakasi -rh -ieuc -Ha", hiragana).chomp
    assert_equal "a ka sa", romanji
  end
end
