class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.3.0.tar.gz"
  sha256 "e8be95e7061cad52caaa98a4d2a25d6bff8fa29c2fa609c3c447124d46b1712b"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "10a7e72d550f30fdbf21231b9d893b8428732d07f41e2d8700c5ec583393f51d"
    sha256 cellar: :any,                 arm64_big_sur:  "f7a14b17399a564f478b39cc553b1893344d5b6f2ab8ac129733aabb628cb20f"
    sha256 cellar: :any,                 monterey:       "9d5ad6be8d1d8b2e499155af059718572173d524b082bba8a629c54dcb25ed5a"
    sha256 cellar: :any,                 big_sur:        "d9af5824c934c6f98d74ea55cb32061c814dd19954ae048b1be6314ee2940b02"
    sha256 cellar: :any,                 catalina:       "a6a14f8c32838d6d243da9c6c5698bbb22ac4c65e25fa9e0e1c977e482ab0242"
    sha256 cellar: :any,                 mojave:         "b0fece1f144232228e72a20e2325abeddbcd47e20a17e00b1cbbaa65099b4641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc2a5c6cd8c0d4458a558dc7c508b7c18783e600cde27e4e1a25b0c8ce44003"
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
