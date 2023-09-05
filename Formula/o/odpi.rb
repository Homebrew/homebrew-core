class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v5.0.0.tar.gz"
  sha256 "4251c8b7725b039f6ab463e4429ba8a7b6578f0aa0172403e59aac2c465ffee5"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d9c6d3b22b66843e7ef5938db8756f1991140b04442d83edce1c00e19e0088d"
    sha256 cellar: :any,                 arm64_monterey: "90e4d0679531b5332e974625571d257c76b0289f7beb851cdeb87f5da085a8da"
    sha256 cellar: :any,                 arm64_big_sur:  "94f188c0aa74cc3bfb9d84a67be67e47a4b71a5d45600499bfd80521e9a2435e"
    sha256 cellar: :any,                 ventura:        "93c96dbb7c326a5b55308bc221b5e08974bd8e9b008e92034be2903b1ebb8fd9"
    sha256 cellar: :any,                 monterey:       "13b28ffb076250f759f57b367b5ab61fc6f4ffa926570bd4182e5a0ed19d5b89"
    sha256 cellar: :any,                 big_sur:        "2aaba644f281d8f195c65fd13557e64992b103b62e89829f522e58b9e6ac3c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4816ae3e7cf5ae1cb4bb242d4ddd713b6cd30e594378b2c1581285003b890a5c"
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
