class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Sep2022-SP1/MonetDB-11.45.11.tar.xz"
  sha256 "f35f3d13facc959f117dcb96ec68c7501d7152078a75ac57641c5b41893a6b73"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a4f86275162be3c6933238a8aafc4bb7a12a980885c6d1d63bcbd069373db6a5"
    sha256 arm64_monterey: "084cfbbc44858e24cf55cc425e4917edd1d3bc087c5ebc65e049118bfc892ad5"
    sha256 arm64_big_sur:  "10213916912b2d8b387c8056e63bc88e3ac90e89e5cb7b43971c84c8d15351c4"
    sha256 ventura:        "5cc2898a341550357e0588087876865bcf92f31b581455836b404b6cf9af5c75"
    sha256 monterey:       "efd39b064e0a6308176ad248ca0fc2677c441ef3ec6a39b3524bf771aa9f1375"
    sha256 big_sur:        "94e4ba3e9764c701e4607ccc90e8c8e1192a44d881a01c3e44a68332221b4aa0"
    sha256 x86_64_linux:   "284c9d2b3b6e7e32537189b596a450ae8858e7b7dd03f1a5df0525d379d97be7"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
