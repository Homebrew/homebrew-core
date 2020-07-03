class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.0.1.tar.gz"
  sha256 "7e4b9f09607e80f9836990678cd45a542eaedf99c3334e1c6f8956ffc5d88c02"

  bottle do
    cellar :any
    sha256 "72b2a344080349aaf5f6aaa6167f43df59e5dd7da3d8912d60eb989058e35624" => :catalina
    sha256 "7505b4d90a69f0fca41be9316063e4eeb858fd7c9b8b795274532eb3b5248b25" => :mojave
    sha256 "fa3483646ef433386054229455ffe1a0109d6bb007cdaa8693c9d97ebd82f301" => :high_sierra
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
