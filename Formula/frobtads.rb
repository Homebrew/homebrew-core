class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "http://www.tads.org/frobtads.htm"
  url "http://www.tads.org/frobtads/frobtads-1.2.3.tar.gz"
  sha256 "88c6a987813d4be1420a1c697e99ecef4fa9dd9bc922be4acf5a3054967ee788"

  bottle do
    sha256 "48bb40f88489ea4a7c8fc0351a23dd4a243ac61b2e710bcd28b22db3320e53a1" => :sierra
    sha256 "0fac4c4359ac59bffa5838884fb53ee6cf18c4b6efbc0d5fa2e16ca1c1675cc6" => :el_capitan
    sha256 "5acaa00274668115972537bf48e6f855b66f7144a2bdfceb4a396d5837dbbc59" => :yosemite
  end

  head do
    url "https://github.com/realnc/frobtads.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
