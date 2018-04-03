class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v2.3.0.tar.gz"
  sha256 "37623afc3620ed6d53026c463e1c4ca02b070cac6ab07a355065ff0d4aef12fe"

  bottle do
    cellar :any
    sha256 "fbbf3776cb70bf16eea2be0a2151a62ad0fecf505e67334c8bb3fbaa06f700e4" => :high_sierra
    sha256 "dca2fffe880396fe7310ba278ac3364391f50b912c58c144026742e4e04683b6" => :sierra
    sha256 "6680cef0614a9940274a744c458d677b9f07e44d706e5ce1b733fe18fc987bbc" => :el_capitan
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
