class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.2.0.tar.gz"
  sha256 "0848887541189ee3b0f663fa8fd077005d06c5406f16d4ab823069b74b14866b"

  bottle do
    cellar :any
    sha256 "4d94566ec71e5e9e5e1c62c8f75b8a123bd2fbef5083a3c9d2d4d318792fcb6d" => :mojave
    sha256 "48771fe3f360759d0b08507a70ead63c0767d7030aa2b4854ea0409671bbd72b" => :high_sierra
    sha256 "61918b74d611026bd1dae27d53d44dc7d2a03966f89c1921cef4950b37037100" => :sierra
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
