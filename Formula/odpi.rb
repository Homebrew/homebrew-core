class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.4.0.tar.gz"
  sha256 "ff0f709baf70af5a46b6346216143bc07782143b37520afb31c057885e1de9fc"

  bottle do
    cellar :any
    sha256 "4b2c0caf3da652eda4abfdf08615adc482d4ab05475e32e087e36b7beb863240" => :high_sierra
    sha256 "c6bd8bb09f912272b134e93c874213ee4857e27c3d1cb032ba66575ae9d2ba02" => :sierra
    sha256 "617d7483d60f14fa341b6952691c6a56d5a572b3133b71ed8a3de034cfa67521" => :el_capitan
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
