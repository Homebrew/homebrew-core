class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.1.0.tar.gz"
  sha256 "b74e06feb1a25d907b97739eda500d03af50c87cd5861b27a0e0baf79f739c06"

  bottle do
    cellar :any
    sha256 "fba4a194950340a9728f4cf9174a2346cb94bec163be02428f6bb2f5cd08f06d" => :high_sierra
    sha256 "d66cce8c4ffa76aa730f6b9dd414ca2d305e1b0db2f47b6936692e4cc239b5e3" => :sierra
    sha256 "55fbdde7662bea5fac2f820525b62ec1ae78c7b78b3a11e5f233354efbe510d2" => :el_capitan
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
