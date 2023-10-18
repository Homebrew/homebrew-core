class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/28877/cdi-2.2.4.tar.gz"
  sha256 "bfa632fe27e04a84d743a6a4d2036488edf725a756d5688058704a9e18da2411"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36f039ebb2913b0c2282c6e9a9541d8f04b445ff7436fcbc91995434e505da12"
    sha256 cellar: :any,                 arm64_ventura:  "31335e8c672e01c9aca72b1bbdf1ab7e28237f00897d1fda630de090cb052fff"
    sha256 cellar: :any,                 arm64_monterey: "551dcb874096596d1d7b14102f5904bce666c24894f68129c69eab29029d4526"
    sha256 cellar: :any,                 arm64_big_sur:  "a058b841424316640ecc4103acf1c81946c108e3cba2271028c50ac415afb0a6"
    sha256 cellar: :any,                 sonoma:         "424152e06b9c94b0f697c709b6eead70871f71ee79f52b8f7b19284ad82bd87b"
    sha256 cellar: :any,                 ventura:        "1af64455db3bd5538105b23dd350fcbe90ecb31c76c01629c153386f09d27452"
    sha256 cellar: :any,                 monterey:       "00396c7be3fc2eb6ce3658a354da69dccebaef3feaa63525c6acc5481dfda75a"
    sha256 cellar: :any,                 big_sur:        "136eebabbece26adf81dca02e5697a03c506dd8d2980efe6c3ab9149e1720662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193228478f070af599e727524701c299dbb67dcc2f6b1478a4eddb4d13248716"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  def install
    args = %W[
      --disable-silent-rules
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end
