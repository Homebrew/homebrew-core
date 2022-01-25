class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.5.tar.gz"
  sha256 "765af0e3194c364504251c19d3362038730752fc5e741078ecdd875de45dbc55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0db2654f01f691a9411c4638df95333839a2beac51651b100bfc67feda4dc278"
    sha256 cellar: :any, arm64_big_sur:  "c6c2ecca2450dc233f3f23fb5a583b38112420434bc6109f1ed882e2529cdbbf"
    sha256 cellar: :any, monterey:       "ea72e15d703fe259406464fae40266c57153d50b7a21f5fe70799c63f60f6221"
    sha256 cellar: :any, big_sur:        "89dd88e145e38197c06c12603dbbe54c25fed2a5ebbf70c0d6a56f60519e5466"
    sha256 cellar: :any, catalina:       "6455fd62cf2cac835e2863e3194887a61598be969ccfd96fbda372cee0516873"
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
