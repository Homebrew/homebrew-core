class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.1.2.tar.gz"
  sha256 "a22e5f5166626c2280a73b93b9a749009d509a0446b5903966c505fba298a8cb"

  bottle do
    cellar :any
    sha256 "1e93ab7b8e0975900e250d695d07b8a9e6202feee4b726ed31a309bc9e36071d" => :mojave
    sha256 "f89cb672eb772e446103f55227dd17c4eeb346dc6a100098d70cbcb0a23294ef" => :high_sierra
    sha256 "c867fb98027fb2fc4695863ea5dd380697b666771c99276c47edf3769db7ef05" => :sierra
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
