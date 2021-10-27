class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.3.tar.gz"
  sha256 "61b45cdfbb772718f00d40da1a4ce268201fd00a61ebb9515460b8dda8557bdb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e43069a0e3e4eace7956060d43cc913f736aaf0fa38fc28d80d640525ed3c23f"
    sha256 cellar: :any, big_sur:       "8694bfb9e3ff0b6f9d5aa7936fbc03607e337e446013cbb5bdbfa3ab6affccfa"
    sha256 cellar: :any, catalina:      "a44a5e35d6b8ca5a8cd4550cf81975f3f26d80df443d968b6d4a4ef019497456"
    sha256 cellar: :any, mojave:        "3223dfa302dfe10af6db64d743285ae85aa212de7fb3e231c08ccf94bd4e711c"
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
