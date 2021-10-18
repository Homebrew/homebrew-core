class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.3.tar.gz"
  sha256 "61b45cdfbb772718f00d40da1a4ce268201fd00a61ebb9515460b8dda8557bdb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f3ec489259da71a4d3275e483d2b8ebbab31294bed962d1fd4e97d645426755"
    sha256 cellar: :any, big_sur:       "d7da7609d9399a60c9291b312a0fcb41e66e34e1fab08b5b5db22f7d0cc94dcb"
    sha256 cellar: :any, catalina:      "955242dc2318ae49b5c43764ba5ad026e83462fe5ce9277803f12219674d10b4"
    sha256 cellar: :any, mojave:        "0d53fde9a7fc26e2125aa87a47134ba13adcfe1b73ec3affb6c81fa2973b7afb"
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
