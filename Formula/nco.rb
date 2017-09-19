class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.9.tar.gz"
  sha256 "efdc0d65d3cc67d0d5dc521709dd0e60b24839e0ae7ded92aaec656890f6f416"

  bottle do
    cellar :any
    sha256 "7c4b404a3611918fd18a898b1b3eef21276cf07dc833d0a34e0784a8d10d75d6" => :high_sierra
    sha256 "8dafcb37843026036c796d8d9ceee983b1deed0e25e0101e6cc59129b7d12f89" => :sierra
    sha256 "04bd384a4acde8da237bb53fd6c72d1b2476d9745938cfb0c5a334d199deea9c" => :el_capitan
    sha256 "d511728b6e740e7b9c865263bd46ecf2be02d49d0e6313a086d9cd66ebbfc809" => :yosemite
  end

  head do
    url "https://github.com/czender/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource("example_nc") do
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
