class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jan2022-SP3/MonetDB-11.43.15.tar.xz"
  sha256 "2a322be251027b86b68177d8a81d4730fcec0b6e1a6e4dfae8c4a2d2f95843bb"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2d3bd76078287f35bbdb5dc42f5a57f9e28d9e31f74d389ffce239e2a01b0886"
    sha256 arm64_big_sur:  "aac092c1ad676920c0e151bf47cdebd262304c7deb792393917adb72b126e089"
    sha256 monterey:       "e385257a57518d2564a40e026b7e820e846b60a21beb94a440a2de805feec564"
    sha256 big_sur:        "aba39e6d1446cfc0f40181777c0b17db781ea8ba888364c3c00fed96e3c58d3c"
    sha256 catalina:       "11eb359ac8ef94e9253c827e8ac9374ca7300fb01eba03fcfa815342b70bf65d"
    sha256 x86_64_linux:   "bde6b3bb04c35c2a23bedc5efb68dd057e3366b1f93dfbb5d7db4a270716ec7f"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lz4"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DRELEASE_VERSION=ON",
                      "-DASSERT=OFF",
                      "-DSTRICT=OFF",
                      "-DTESTING=OFF",
                      "-DFITS=OFF",
                      "-DGEOM=OFF",
                      "-DNETCDF=OFF",
                      "-DODBC=OFF",
                      "-DPY3INTEGRATION=OFF",
                      "-DRINTEGRATION=OFF",
                      "-DSHP=OFF",
                      "-DWITH_BZ2=ON",
                      "-DWITH_CMOCKA=OFF",
                      "-DWITH_CURL=ON",
                      "-DWITH_LZ4=ON",
                      "-DWITH_LZMA=ON",
                      "-DWITH_PCRE=ON",
                      "-DWITH_PROJ=OFF",
                      "-DWITH_SNAPPY=OFF",
                      "-DWITH_XML2=ON",
                      "-DWITH_ZLIB=ON"
      # remove reference to shims directory from compilation/linking info
      inreplace "tools/mserver/monet_version.c", %r{"/[^ ]*/}, "\""
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system("#{bin}/monetdbd", "create", "#{testpath}/dbfarm")
    assert_predicate testpath/"dbfarm", :exist?
  end
end
