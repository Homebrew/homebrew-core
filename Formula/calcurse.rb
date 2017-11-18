class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "http://calcurse.org/"
  url "http://calcurse.org/files/calcurse-4.3.0.tar.gz"
  sha256 "31ecc3dc09e1e561502b4c94f965ed6b167c03e9418438c4a7ad5bad2c785f9a"

  bottle do
    sha256 "97246933a756e39d96e5a26ce0e0246f825305912c62ae19aaad955c572a6c33" => :high_sierra
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
