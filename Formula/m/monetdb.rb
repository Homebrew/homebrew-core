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
    sha256 arm64_sonoma:   "336b20d1ffeaa7b34327044fbdbac0246790efbf6facc38b6d5afa4eb69b7dcc"
    sha256 arm64_ventura:  "31dd2741dd9f5e530c86416815fd3bf377c54e8dcb809ccd729774ab42e9ba96"
    sha256 arm64_monterey: "eb79b56cabc01c0dc302585fb26ef543e5a49b3f7120c6d00e85533eb6dc3a29"
    sha256 sonoma:         "3f7020ec4bc81578af0b3d404f6cfc8457b9570c4ece76dc01a5e7a01db04605"
    sha256 ventura:        "06bce53afb3601d435a871fe95279d84fe809f738fd940365d90b10ac539c1a1"
    sha256 monterey:       "6c300e106b00522af7372f01e36cd46ac324c9ebe261cbdc3863206a1cd0ea3f"
    sha256 x86_64_linux:   "dee49b401f9223551cbd6b8c6c8ad9b39ff6e90f81fb8cbe32df0bbc7e59fd56"
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
