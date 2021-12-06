class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.5.tar.gz"
  sha256 "765af0e3194c364504251c19d3362038730752fc5e741078ecdd875de45dbc55"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "bc221c7f66d7f1ae0605669e58bcf8b6bf7dc7b47c99ccb647d69de8fbb5eb98"
    sha256 cellar: :any, arm64_big_sur:  "571721d0a06093a7d17710d18a782f35ddf5acd3f4a084f0db0b8d14e4751d3f"
    sha256 cellar: :any, monterey:       "e6f67086398149c73c4d8a07d50b0a4cb822aabb82c6156391c96abd49a9841f"
    sha256 cellar: :any, big_sur:        "45ac766fd0da5b4300b9205a3eed98d85540640785a4475477fab0dd3d23736d"
    sha256 cellar: :any, catalina:       "6dcdc818e476d97108cc26bdf8181b9f43c1953d6067e7d6fc3d6243a4921e42"
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

  resource "homebrew-example_nc" do
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
    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
