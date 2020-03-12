class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.3.0.tar.gz"
  sha256 "113349161c95e6a896fafed6f1f4160547435848b8fe06fce9659738a7c5e8f5"

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
