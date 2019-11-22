class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v3.2.2.tar.gz"
  sha256 "9fc8f8fd901d2de4fc8394bde72fc5f6fa91ae72a571df988a0993aba2db8e66"

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
