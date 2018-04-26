class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.3.1.tar.gz"
  sha256 "09d122f1dce983045a4c30facd5703207934b7ebb8c736abdc400b7090119827"

  bottle do
    cellar :any
    sha256 "221ad6785bf283e4e4f39bbc2258a1c043c20486b598bc824373cf184b01bc60" => :high_sierra
    sha256 "502e9363e3715f5056e0a75bc0df149b29768eb76b1ac2768f837661ce18ef04" => :sierra
    sha256 "ab7c17fad9b0b042f8667a29e8a2bfc4cf0e943fd329d0c9090077fc6e500f8c" => :el_capitan
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
