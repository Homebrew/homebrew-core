class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.2.1.tar.gz"
  sha256 "f0961647a336980ae26ca93cc15b3c8a882f5d68b3b5ee123032fd71122503c8"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f7a14b17399a564f478b39cc553b1893344d5b6f2ab8ac129733aabb628cb20f"
    sha256 cellar: :any, big_sur:       "d9af5824c934c6f98d74ea55cb32061c814dd19954ae048b1be6314ee2940b02"
    sha256 cellar: :any, catalina:      "a6a14f8c32838d6d243da9c6c5698bbb22ac4c65e25fa9e0e1c977e482ab0242"
    sha256 cellar: :any, mojave:        "b0fece1f144232228e72a20e2325abeddbcd47e20a17e00b1cbbaa65099b4641"
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
