class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.6.1.tar.gz"
  sha256 "30a50f831436528dcd5c8409e0c5e493838e0626c7718c8ec2c8f3e4f2e4b4ab"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29c0aefa5550a599fc2547e5a2fa78be214880e84fc9e5a9b4c4cdab27009426"
    sha256 cellar: :any,                 arm64_monterey: "e113d66087633f040ea6196f00674ffd0973ff033b2bdcef2bf322df1d6abda0"
    sha256 cellar: :any,                 arm64_big_sur:  "5bd09af65c636f9f5ce46116e3dfabc8fe1d5533c72fbd479598146a4c8723fc"
    sha256 cellar: :any,                 ventura:        "5a658bfc7ef147112a666391048fb3be2a546316df8662d3df025f99ebc2c006"
    sha256 cellar: :any,                 monterey:       "05dfb6bfaa79212ec76f959aeeccd05aa721157431fcad4509a790f8dbf90916"
    sha256 cellar: :any,                 big_sur:        "f4d457db5ebecd652759d18b3a050e1b76606a6515c2d9578071a32a08dac826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5acc9a1232a419c84587cb40dcd8b5e1adc86d2415294cb7cbba03fe4773a830"
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
