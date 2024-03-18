class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2023-SP1/MonetDB-11.49.5.tar.xz"
  sha256 "44a6299c45431bde2966c06ab3e40a34b593145e3c3aa6f08a3ec131d91ab7ab"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2d95c3fafccff542dbc356985d2640255e2d0f23a41d0d08813dbaf5c318ff41"
    sha256 arm64_ventura:  "9a29399c50b5bbf938482f011c2f026bb9a595083ebc37ca98a6b6c180e39a06"
    sha256 arm64_monterey: "13d26ec289fe0257a7fc0d59f76c6367b673ec67e8e96f73fb9cc157c39e4d79"
    sha256 sonoma:         "97ea142c95c5a1a0e94a410a7863a122f905dbe40acd6edbc3057d0e66c99573"
    sha256 ventura:        "5ac0df816b0d62cb605ec1aaf301b585a8b0ec9863722c186bec1796aa8e82eb"
    sha256 monterey:       "6a823d3d8d804ea2e80f1e1e89dc21ae8a0c1233c5cbb9246ff20849982de965"
    sha256 x86_64_linux:   "a803b302bd97f824d11c3320c3dcb70ecd7aba94c7cc96e22b75d9cc9644da29"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build

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
                      "-DWITH_OPENSSL=ON",
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
