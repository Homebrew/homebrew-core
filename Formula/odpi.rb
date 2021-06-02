class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.2.1.tar.gz"
  sha256 "f0961647a336980ae26ca93cc15b3c8a882f5d68b3b5ee123032fd71122503c8"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0a692da83a6cf1036c9a588485707a04ef60ecd13b8b3d671e78d2e04a71f030"
    sha256 cellar: :any, big_sur:       "1b5ea7539919dc492e3ed06a9a42bf8642fe5cc55fa63e21c8d9931c14f6b807"
    sha256 cellar: :any, catalina:      "b293495736f6663b131ce171b3adaf75723f9155a2a33d0969c93f6bd34ef12f"
    sha256 cellar: :any, mojave:        "368ed5728712df73ca2fb82c299fc3c251a20d6b59d143ca7a6f44da1b3fbe61"
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
