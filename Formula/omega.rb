class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.17/xapian-omega-1.4.17.tar.xz"
  sha256 "d52eea4cd1bbf334e84af6d41ea3424466ab75e3dadd4a736e4eb0c976392d16"
  license "GPL-2.0"

  bottle do
    sha256 "d80c1433e808dd54461927f53d63699045848f998833f6a677ca618371ee6a06" => :big_sur
    sha256 "ceca2f89cf750438ff3d3e58b5167bf4013ae7a42eb51627653acf23bfbe8e47" => :arm64_big_sur
    sha256 "17a298c14fbbf86f3b3e8914ae2e9cf36c1404cc92d53f41b73cd7fb02cb9a6a" => :catalina
    sha256 "fce0483526b6996f89bcfe7374446b9cccdfcf4c32a4a4b2bdbe172d45035a63" => :mojave
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
