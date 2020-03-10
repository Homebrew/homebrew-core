class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.3.0.tar.gz"
  sha256 "113349161c95e6a896fafed6f1f4160547435848b8fe06fce9659738a7c5e8f5"

  bottle do
    cellar :any
    sha256 "2003973f8ef9ae4fc3d122ceba50b8a9e96c8b51401083801999743ef8c938b0" => :catalina
    sha256 "c6ccc7150c6b9c4ac1ba890c47a54227d3d2df0599aedeac97bf6719cf85594a" => :mojave
    sha256 "67d62026272947a8b94b1f6d40569abbba93a47ac7a21bcc38ff8a14a52e9162" => :high_sierra
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
