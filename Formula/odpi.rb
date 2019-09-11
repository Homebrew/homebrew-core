class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.2.0.tar.gz"
  sha256 "0848887541189ee3b0f663fa8fd077005d06c5406f16d4ab823069b74b14866b"

  bottle do
    cellar :any
    sha256 "160188a35be171a76d8f29246526a88b2cb6fc6c60c0d39debdb80f7e2306b7b" => :mojave
    sha256 "f479192ad5a7de7b0836462e27d864ae91216f367a0b8b9f5eaa4fa33965eeeb" => :high_sierra
    sha256 "c280629e175f9065989cdb8495474c54a9c021af3f8b3200277f57fe99148064" => :sierra
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
