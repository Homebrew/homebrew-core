class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29871/cdi-2.5.1.1.tar.gz"
  sha256 "a78c577324eb99ef461e90f717b75a1843304ac6613ebd168fdad12f84d78539"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ba79bdfd5b3ae2ee2c1761091adec216dd87fcd07dfd50cfebaa4eb95ff5cc5"
    sha256 cellar: :any,                 arm64_sonoma:  "7c4791aa173ee41b0f3769d41252379a538cc4eb815adfe455f2371411a07cb0"
    sha256 cellar: :any,                 arm64_ventura: "672518b37e775349dd80650bf633d3fe0c38c0929cec798ba382a120be8b02f0"
    sha256 cellar: :any,                 sonoma:        "fd7bd1151d508897c5ab9b2e610af65e6b1741cff84dab549d8068c2502581e3"
    sha256 cellar: :any,                 ventura:       "cf645ed409a66f613ee7ee117e1b90e806fc6557f82dabaff414c298e9f5b787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "341ebba037f6dfc1b38692328d8eea830da74611f85ecf17b0607031072214c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330cd470852be10e82afd99a977270252a46eb9ee67fe543334715861b5304aa"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "util-linux"
  end

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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end
