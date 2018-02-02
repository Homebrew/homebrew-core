class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.2.tar.gz"
  sha256 "40e719a4b8da36970333c9e24f2963441bfa65f155ff3d30245751ccec2cb004"

  bottle do
    cellar :any
    sha256 "972cd613d8aa1418260e1c7e59010a47bff3a2d0cad9e39e86987bf344396ba8" => :high_sierra
    sha256 "91429aa7f368bd46d62411762ed8bb34927f04c87d7c932093a3fcddf0ef7975" => :sierra
    sha256 "8eb24dd683afdad86d900f6c9eed5bc679b53d4dfe347d28a46ad36eeaa53830" => :el_capitan
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
