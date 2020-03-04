class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.15/xapian-omega-1.4.15.tar.xz"
  sha256 "c3112b920809a42a3b63ccaa17425b9a2f55f9a06a5091c402455fcf347fc3d2"

  bottle do
    sha256 "9b728b5bbc02212b6f0121db7275f563b5ec69241fceac5129f56e9077ea90f2" => :catalina
    sha256 "bb7b70cb7e9c92e6174226d93483fa1d04f73c47a3da9370231ef0424066054c" => :mojave
    sha256 "b39bad45e77fb4bed15f3c6256604dbd70ea8d757c8825bd4fd245ef8266aaba" => :high_sierra
  end

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
