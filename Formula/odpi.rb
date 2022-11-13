class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.6.0.tar.gz"
  sha256 "fdb07c734c59b807787b5677ef23edd52766bd2d3cf075d285994793edeb40c5"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8dd43b72e0d1945818be0256dbc4e077fac5a8a75daaf9489fdb9f325f0e57b6"
    sha256 cellar: :any,                 arm64_monterey: "a9cc873c661724322d03bcaea830790ca64a9ae25939989945f90b7a912ac17a"
    sha256 cellar: :any,                 arm64_big_sur:  "f6ee3453a6b5c559702039fc82791a5401926c1d8cb0f583227ece09fb3e892f"
    sha256 cellar: :any,                 monterey:       "bf9c773514668087b579a17f821fdb57de75f150cf2bcc78e1eedf5d3c4a2634"
    sha256 cellar: :any,                 big_sur:        "fab05b206080566c121e15dcf01c8611ea89ff15ef482d4cf7f0e177a57dcaf7"
    sha256 cellar: :any,                 catalina:       "fd24291c44b33e9cfa376b41c14a4fd914d30c20c147a0551ddbbf79ea17fe2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6d424058b8def1ae140613e19dca697b8211768c3d2a996b979977ef265f5e"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
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
