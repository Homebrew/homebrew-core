class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.19/xapian-omega-1.4.19.tar.xz"
  sha256 "e4b2ef287e55df6754a1cb13b7677231bfda6df22567d28944046f6994d5cd8c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "def2dad644651a029f624fdfcc049eb2c38615ac3abdd83dca5b16cc91dc6d1c"
    sha256 arm64_big_sur:  "4888077491e9231306b5af3b504e84fd01c20a0d13fcb10140c1d1ead55ae279"
    sha256 monterey:       "507ed2fb6350f5c59a50c8bb0da7e14d0aacb6651d29ff8ec921bbf01bd20612"
    sha256 big_sur:        "75f151d449786a9b7dc439aa276a06c4df89aeb00cec7b58fb09241795b7b281"
    sha256 catalina:       "f8712f187e62c9a7414f82c5eab0aefb7752372ece97e2ba9ba6ed1a70f5952d"
    sha256 x86_64_linux:   "3135531c3195dd0190d48e2e8d4f29743d63ea9a9abbe9b22edb0c100cc4e542"
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
