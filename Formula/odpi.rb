class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.3.0.tar.gz"
  sha256 "e8be95e7061cad52caaa98a4d2a25d6bff8fa29c2fa609c3c447124d46b1712b"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7244b4b1b2491a0bca077aa4d2bb530df059206e56d1a5d6103983f9e88edaba"
    sha256 cellar: :any,                 arm64_big_sur:  "8315751a4d068e761b9710daa4251edd61c01752c021fc93045f02083e5dec14"
    sha256 cellar: :any,                 monterey:       "a6efa2963f2a11b1316f7f883cdab0ba8a99b0a1e1b5324c9c960094de152e85"
    sha256 cellar: :any,                 big_sur:        "7dc8341678ef3c3b5e8e3ec798b50aab4fe5f9330b57931c55a25e8f6c457ca5"
    sha256 cellar: :any,                 catalina:       "05db0489fa10e27600c35f22669e3090b3bf17ca00cd7c97966f62e1d314c7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b415bbfb0f8b13d559f2b5f2119a96e24d58d1a35d8f2ecde4ca76169d74028"
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
