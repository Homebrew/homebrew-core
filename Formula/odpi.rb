class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.1.3.tar.gz"
  sha256 "1a2964bc04de33cdbfeec90f2b89f9c2a1310308be9a027d0d8056b93803755e"

  bottle do
    cellar :any
    sha256 "b6b5c66a8252df998fb93ce915ad48abd0208538cb6886f9ee545371ddc48fed" => :mojave
    sha256 "eff16851ae1a40cdfd8b20617b586831ba1d930b996af0c974601858db364a11" => :high_sierra
    sha256 "c13eace00296024d7ee190e234735008252e00b35568e0a0c35213ad7700492b" => :sierra
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
