class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.6.tar.gz"
  sha256 "3de8b57a3d130cb2881ea52d3aa9ce1feedb1b57b7daa4eb37f751404f90fc22"

  livecheck do
    url :homepage
    regex(%r{current version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    cellar :any
    sha256 "4bac859e3460476137f1596a36015e9c0d3e1d2b46a9aa47171cabf7af5f5d71" => :catalina
    sha256 "68d9f5926df0ca43cfda25423a405b837de81575eec025944f6ec67611422742" => :mojave
    sha256 "959ce4d49a7419b01acf9e66c9d0f77a213c067f723b87d08ac6aaa21d054fe9" => :high_sierra
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check"
    system "make", "install"

    system "doxygen"
    doc.install "html"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "freexl.h"

      int main()
      {
          printf(freexl_version());
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lfreexl", "test.c", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
