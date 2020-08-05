class Cgoban < Formula
  desc "Go-related services"
  homepage "https://cgoban1.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cgoban1/cgoban1/1.9.14/cgoban-1.9.14.tar.gz"
  sha256 "3b8a6fc0e989bf977fcd9a65a367aa18e34c6e25800e78dd8f0063fa549c9b62"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b8613fe9566746c60a0ec45830b5c687d54cbaa6107179906248fa6094e856d" => :catalina
    sha256 "fd7177595494fb367982e080af14fb7a249d6651a73a1b33f63394f9546fc837" => :mojave
    sha256 "38bb87533d7c54253a2836af87c326651dda87c046f3803189308b155651e825" => :high_sierra
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-x"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/cgoban --version")
  end
end
