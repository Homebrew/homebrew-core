class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fb15fc6efff1c2266f858dc081bb5d2d67e8e2ae2abc50a23883879fab343f22" => :mojave
    sha256 "8ba5137f3ca736e16650418d4ea075f0e2c85ea87d88824e68f367bf5c4216dd" => :high_sierra
    sha256 "da1f2677ac3df8180bfebd9fa59804610d4b3e0020adcc47ffe839ad831006e4" => :sierra
    sha256 "b816f165673f58fb952669c7fa542b2fe52257e6572853785efee0048ea35d6a" => :el_capitan
    sha256 "95e74408a4b9dca4e7a939d2ff79e9ab16f3193622027d3d741eb6fc9cc7695d" => :yosemite
    sha256 "048947d9343c8848897be272cae74d98cd869fa3d64fa6f2bfe82cb68ca100b9" => :mavericks
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
