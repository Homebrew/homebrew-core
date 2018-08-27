class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.6.tar.gz"
  sha256 "c7926163b204573b7bf7b6e3c9bcfa15b2cc04c0f494dbc0c6829ee8c2f015b3"
  revision 1

  bottle do
    cellar :any
    sha256 "591f73b67b3a5abdeb92cb6d8dbf3bb050a4da367b809ea2ca03c9964ade7a1c" => :mojave
    sha256 "d9565e4d3bb35116a48cff9da7da62aa8da065c27e9f81e1f22c6b84ceeb39d9" => :high_sierra
    sha256 "1fbecc40e802d1b4efd7ba45764029d8cce15481586e8eb727681c86f4e456e3" => :sierra
    sha256 "bc60118b78e08dc5b1b780769f86019d4443c56a12ad63a3966a213ef3385555" => :el_capitan
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

    inreplace "configure" do |s|
      # The Antlr 2.x program installed by Homebrew is called antlr2
      s.gsub! "for ac_prog in runantlr antlr", "for ac_prog in runantlr antlr2"
    end

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
