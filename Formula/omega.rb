class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.15/xapian-omega-1.4.15.tar.xz"
  sha256 "c3112b920809a42a3b63ccaa17425b9a2f55f9a06a5091c402455fcf347fc3d2"

  bottle do
    sha256 "74c6765d98613554c318770837e011e15ddb3ac9c0ab89ea9daf5222cadfb442" => :catalina
    sha256 "b63722eb7af499fbf5a9d18000e73140f6e678f6b74b392ba211a28d9c927537" => :mojave
    sha256 "fea9fe989568f59aeedd52eb6b0c39c26cb15f01eeb1b3013a79e14c0dee7c1f" => :high_sierra
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
