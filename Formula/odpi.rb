class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.4.2.tar.gz"
  sha256 "b161a835829c2ea6e85be9e668a852cba0aa84c2f35d1e437d0c40bbd1588643"

  bottle do
    cellar :any
    sha256 "c9d39cc60e3b86a0f2c1e1ceab05bbe6d41b4fc68444ab3731e9b2c40437f75b" => :mojave
    sha256 "0b8f47fd36581501faf5d90da3e71edb27fddbdfd5bf35cdc2d7af330be517fe" => :high_sierra
    sha256 "9e4a3cb977bd94d4a03e2069deb57e13e6b91acc7ae2fc069cfd483d6ae0223c" => :sierra
    sha256 "d7497b877ba35e99b966ccbc294bf960a04fec4877163587f1555f578067cf55" => :el_capitan
  end

  def install
    system "make"

    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
