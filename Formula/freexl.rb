class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.5.tar.gz"
  sha256 "3dc9b150d218b0e280a3d6a41d93c1e45f4d7155829d75f1e5bf3e0b0de6750d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1e8467da269dde8d829ed6cc9df1e11748badce459917739539df22b4d6b681a" => :catalina
    sha256 "074e0ab64d2163799d917733f769843cc19613497adcabcde2e57a4487d8e1f8" => :mojave
    sha256 "53fa9067f9cd0a809368ae614b198337f271bbe95fe0aed9fde7162b28bcbb46" => :high_sierra
    sha256 "876c7d693c24c6721da1a15869b3f2bf40a2ebe3d911780aaa97499ace91cad0" => :sierra
    sha256 "e4c2ed6d07840d5c4fb619048073eb349a8d31dbabc2f2a783fef1978c86b573" => :el_capitan
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
