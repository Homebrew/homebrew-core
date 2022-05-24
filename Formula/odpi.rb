class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.4.0.tar.gz"
  sha256 "e7c9e72f486b8560d5bdfd955ea4564fd92307ed8bb944edfc2055bd93c37f7c"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a5678b3ab51f94facb76d255e272f983efae0808e144557773660ade2603e0b"
    sha256 cellar: :any,                 arm64_big_sur:  "651650025a1cae11f3bc5df463c3998029379104d52e2b878f95203550a90aed"
    sha256 cellar: :any,                 monterey:       "b10b31dcebb72aa5952d874521cc7c214ccf82c964c8019e9ffb116840410f94"
    sha256 cellar: :any,                 big_sur:        "4987a9087ff2901dd4a21a08bce99a1c7908e1bdb03ef3dd45e0df8779e12eb1"
    sha256 cellar: :any,                 catalina:       "3a4f46b15d2171344684e6d2781d860544e5d8e802f81799cbf057617eb1f556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87dbcb17530adaebade1a394035613ec9e3239f2f314483b5e1660a5f5c9d914"
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
