class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.9.tar.gz"
  sha256 "058f04bd1c57354f8e3c90e6529f7f5a4542bb702419bfbbbdc500d5e1ed06ca"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e6deb6e7577242f5620e42b8ac9f63a82605fecb4e281b592f81fb804b355689"
    sha256 cellar: :any, big_sur:       "4695324723d4357b8829911e720db632a4a263d2f5931e802c78d6581e21ef8b"
    sha256 cellar: :any, catalina:      "6209dc0ea872a1fae79141608f93ee3d25198d17c2beb55a703a8d34344b6479"
    sha256 cellar: :any, mojave:        "cb9a44f907db981003b8c2ccb7b53b857f7b293cdcc004d3e17dbccb548ca2f4"
  end

  head do
    url "https://github.com/nco/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource "example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
