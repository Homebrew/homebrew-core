class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.4.2.tar.gz"
  sha256 "b161a835829c2ea6e85be9e668a852cba0aa84c2f35d1e437d0c40bbd1588643"

  bottle do
    cellar :any
    sha256 "c37e2a4ddb1ca25225d8888e29bdb9576c21522132fb3ab4a7f1bf9832ef3fb6" => :high_sierra
    sha256 "96d2d453241dd2290514f0b3b6d704c2a6b7c6d06702801f0c5b319f9bdb4e7d" => :sierra
    sha256 "17377a509fe09e9cd87251b0f132172628d54bab53e3e390a9686c064ca4fb3b" => :el_capitan
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
