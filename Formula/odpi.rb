class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.0.2.tar.gz"
  sha256 "235fb10412b43b65905b77b33efcc8d5c036e04d058e1ed13f7e2b2054fcfae9"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    cellar :any
    sha256 "9817fa422fa89f12395b6f981f731e2392d6dd0c5e6b026adc655eb05fb33d0d" => :catalina
    sha256 "1375a9d693cc5ef4c41b2b4c625d738191884e28c97e6e64314a26b446e8ec12" => :mojave
    sha256 "84afef53c203bfe74cfabefb188e8d09067d0e282f0f550901a131601faef769" => :high_sierra
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
