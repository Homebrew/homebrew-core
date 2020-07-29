class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.0.1.tar.gz"
  sha256 "7e4b9f09607e80f9836990678cd45a542eaedf99c3334e1c6f8956ffc5d88c02"
  # license ["Apache-2.0", "UPL-1.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "e5694f2aaf70a12bd5c4706baf2a245f9a263b8c397bf2d072d1d3a8a487787b" => :catalina
    sha256 "7290f588c312521a1468696d8f6d463fdc804655c385292fbde07808c5929343" => :mojave
    sha256 "64a67b0695f49cebf4d21495278752babdc34ab44639fec64c645cf08fdfd112" => :high_sierra
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
