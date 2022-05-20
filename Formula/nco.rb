class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.7.tar.gz"
  sha256 "6ddb397e7de4a7876e7d84ea82d4ee716cfd60ad8ee50ef49716945c505cbc1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4f48120f508b526c1d65e1e49a1aac82b9f1bc475d35eb9674689e25446df57f"
    sha256 cellar: :any, arm64_big_sur:  "36bb42798bdc5522cce9eb0736e05350d6f5c1723d34d058275ab56194138c55"
    sha256 cellar: :any, monterey:       "d5592375add37d98bbb1eb9257a52044cea0aacd6619a34723a9a1882cbc7a04"
    sha256 cellar: :any, big_sur:        "1f9458115d4ba8666df67010b6699a25a7d99a273f7bb4448c1ad7b0daea0b3e"
    sha256 cellar: :any, catalina:       "5aabec029e698e23958d49210ff8efb12afc17e3cb0f5cc98615ad3317acce5f"
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
