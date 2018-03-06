class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.2.1.tar.gz"
  sha256 "12fbc82d8f49a6661ebb30b5e51f44436b01d1639a4a20a7af2c07e686c42844"

  bottle do
    cellar :any
    sha256 "247a89e6c5532890f8b2d293c8ec3f6b3f38004b87a7c0cc26e64b8692013635" => :high_sierra
    sha256 "b4ca5bd445f35f4807ee2217eac59ad39539f38a9e67b8457605767a54d364b0" => :sierra
    sha256 "34a4ccdb92a28f41e95f5f43e7a2505091a12adada01f8873f3707c39df6989d" => :el_capitan
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
