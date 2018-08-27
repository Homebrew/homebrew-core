class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.6.tar.gz"
  sha256 "c7926163b204573b7bf7b6e3c9bcfa15b2cc04c0f494dbc0c6829ee8c2f015b3"
  revision 1

  bottle do
    cellar :any
    sha256 "514242182db426c922bd80a99981e25002bf4d477d4efcb590d10ac012800e58" => :high_sierra
    sha256 "05fb5f98c1cffb831c745a9505dcc1e15f0251c85779218dffceb22e1276ecc2" => :sierra
    sha256 "be404bc8cdcd9f38bfaf9251479e8f94c1c548bc901732d19767f14b3349fb44" => :el_capitan
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
