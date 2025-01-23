class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2024-SP2/MonetDB-11.51.7.tar.xz"
  sha256 "98fd6512858911b0e6e3a0f62432f4ac7acb34ca8b6adc882db6e3315fc297c6"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3009b9b02155c2ac62e6fb747cf989222eb0b27360c7de286b332f0efdfe86c8"
    sha256 arm64_sonoma:  "536cfdd1b67f37b85418bcf88b7a7c353662f23ce1497958f4aae4aa598482c3"
    sha256 arm64_ventura: "8dff397a6cd6919941bc677d5565358ad2140234949cc8ab17249d9d8ad6f71c"
    sha256 sonoma:        "d1865385c7eee772a7c81eaf3dac6c9c37f5513a8e098dcde414dc5c1195c266"
    sha256 ventura:       "f5e1327e061fe9246a0d9cbaeeae8eaa31cfd057021e1061df354d20fdfb44df"
    sha256 x86_64_linux:  "79e53c9d3b5860df89ba17b444f4169c4daa4b4e9579e8888691b722dfc55971"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
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
                    "-DWITH_OPENSSL=ON",
                    "-DWITH_PCRE=ON",
                    "-DWITH_PROJ=OFF",
                    "-DWITH_XML2=ON",
                    "-DWITH_ZLIB=ON",
                    *std_cmake_args
    # remove reference to shims directory from compilation/linking info
    inreplace "build/tools/mserver/monet_version.c", %r{"/[^ ]*/}, "\""
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system bin/"monetdbd", "create", testpath/"dbfarm"
    assert_path_exists testpath/"dbfarm"
  end
end
