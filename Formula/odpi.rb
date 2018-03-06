class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.2.1.tar.gz"
  sha256 "12fbc82d8f49a6661ebb30b5e51f44436b01d1639a4a20a7af2c07e686c42844"

  bottle do
    cellar :any
    sha256 "2cf3381b3ac13730425587f7713cec41415b2433de6c1501c5d06d45e5fcba04" => :high_sierra
    sha256 "ddee0c92562aabb96e5d64056f2bc1d3aec62710dbf9095fbd503cb867df7aae" => :sierra
    sha256 "f3b1efc4e54ebf61133cd6977c87c6bf76e9081dfba7b645cb224d44ac7953e1" => :el_capitan
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
