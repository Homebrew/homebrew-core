class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.18/xapian-omega-1.4.18.tar.xz"
  sha256 "14bec53234bea5eb36aa4b91940842e62c7968f4fd68c959db396c15069acbaf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e93f8e12861eae4aef56482f4daad7d017060bb420cbb9b6973dc1e4756286e1"
    sha256 big_sur:       "a9adc43192d3cfefc48b5102405b8542549336ae7c7a73c4f964c64f2f3c9306"
    sha256 catalina:      "171d9ac0866a0124ef2da5c8f23bbe755ba8db69dd30b7ecf6ef2a924f288444"
    sha256 mojave:        "21777656dec508784295f638ecce1a7c54aa32870b16d6d5bf9951b01a7803a2"
    sha256 x86_64_linux:  "a8b1b2fafdc1bc9285c4be52516c8605f9e99c66cc0f82cb910b6d26698ee995"
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
