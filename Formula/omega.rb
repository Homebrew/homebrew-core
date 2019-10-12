class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.12/xapian-omega-1.4.12.tar.xz"
  sha256 "0e6767d4571b6b58ae4e65b0b60cce57909f11aec245fc557eb9d13a47ca19ce"

  bottle do
    sha256 "710f1f33704884f039a21e5c02f470cfcb7780ae3c10b7c7bf11366c3095408c" => :catalina
    sha256 "bc76776c8d52a58350a36c3076f2aaa93d2d67f319d0a05dca46f1495a1adeb2" => :mojave
    sha256 "29ae06a6963243aa03b4a020d0ea6d75deeeb9e250f2e9af82ad597e80a9c02c" => :high_sierra
    sha256 "bd44602eb83fea9ea9b9b833ec376107b7c8eea0cb4e61c1e8b878829f264690" => :sierra
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
