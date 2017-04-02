class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "http://calcurse.org/"
  url "http://calcurse.org/files/calcurse-4.2.2.tar.gz"
  sha256 "c6881ddbd1cc7fbd02898187ac0fb4c6d8ac4c2715909b1cf00fb7a90cf08046"

  bottle do
    sha256 "375463064c0e4aefd6f63225fb75f218595ee075213f105b3ee823751aa9fe75" => :sierra
    sha256 "83948ec7e431450ac3141b4a4ab7fa9c1699763e532146696d79d9a9419e3d2d" => :el_capitan
    sha256 "bb97afde65f1066d39f8471e0f53f2cefc694eda3693ecb8c1e1b65f5197aec5" => :yosemite
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
