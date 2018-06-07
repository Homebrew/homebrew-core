class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.4.0.tar.gz"
  sha256 "ff0f709baf70af5a46b6346216143bc07782143b37520afb31c057885e1de9fc"

  bottle do
    cellar :any
    sha256 "a621551f8d2a1a58839718316bf34e1f076151171c45e38d06f9a26f5af6686c" => :high_sierra
    sha256 "61c6fc47f7bcbf3211b811778dbbc031e22f4e07b2b463381a4c5d39884d0862" => :sierra
    sha256 "d20ee590095eca3dcd174ba6fa94ec0a28a9495b7026126a0a46bc0583a8bbda" => :el_capitan
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
