class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.1.2.tar.gz"
  sha256 "a22e5f5166626c2280a73b93b9a749009d509a0446b5903966c505fba298a8cb"

  bottle do
    cellar :any
    sha256 "9c5ff5dfe555154be3dc9a3fd51675e92a022fb9f8c7517091879f14e5fc8933" => :mojave
    sha256 "f5f617075d281fc1cf029bd61502dba281815e5d96a786da7b022ed08b691568" => :high_sierra
    sha256 "036ad1ef32fbda26d7267cbb7f0994b51862c2579ea25f4284f480eb78b7b371" => :sierra
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
