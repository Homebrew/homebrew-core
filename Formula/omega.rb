class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.16/xapian-omega-1.4.16.tar.xz"
  sha256 "b4fbeb9922d84af42ba80c0258cd07d103fd7f56c719f147049aa84598557694"
  license "GPL-2.0"

  bottle do
    sha256 "21def29541640883bd956e842a3370d9ac7dde45bd166add19ca83013f86189f" => :catalina
    sha256 "5625e477813a8c7bd720e17416b6dd80faf959f5d7210c3262031ba30c3e1f6e" => :mojave
    sha256 "ff44c076ce6ad71238f2293e35ad7c8fed610dfeb5eb15e8a52c0e68d9a0b62d" => :high_sierra
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
