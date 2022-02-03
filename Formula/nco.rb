class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.6.tar.gz"
  sha256 "d4c74e0268af94bdddcb0c77189830992f61c04147c23669b66470f1a8595d60"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1fbc9a0b68655d2fc332e71066ca282ca31a256b7cd3be834efcf8868596c26e"
    sha256 cellar: :any, arm64_big_sur:  "14e2e2b9e439a2113464807f2834c9483fce6bf114f399a8e154686ffd3f5f00"
    sha256 cellar: :any, monterey:       "3e38e7b44395e70b0f8460cdc1a1f45c7a471b1d1e2f2318abc1d0c5827ad56e"
    sha256 cellar: :any, big_sur:        "9d4cc4efdf377e413d72f22fbf4d251062c9fb6201acdea9079e72c3e277a75d"
    sha256 cellar: :any, catalina:       "6fb6d272f8eb39c58dba4cecf8816a3a9c30faff1d135cf202902748a3a9608a"
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
