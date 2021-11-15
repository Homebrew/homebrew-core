class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jul2021-SP1/MonetDB-11.41.11.tar.xz"
  sha256 "2e81a98e06820dfaf56770af027e8da4a8dcc533d3599b9cc2b5a2e1efdc07af"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/Latest/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "033a246468cf78e11bee28e8f72898bde13a8744b9c1419dd01c3af0a96ccc42"
    sha256 arm64_big_sur:  "6d8d1d9adac551e246d2079458e9adf3838ada6ce4d37baabf60837e9aab953f"
    sha256 monterey:       "053ea139c78f4f2d1922217603e8d76624745c98c8e9fb9989ec1d2605663a20"
    sha256 big_sur:        "94f9b822f40a13cb4188b0308f59c66549356f03db8c63c3b621d79b4ed3ec28"
    sha256 catalina:       "0559cff129551b30d75668d818bce67e1d210b3dba3673c174341d8cd5d3f8e4"
    sha256 mojave:         "ed43da831a5b713d0f37f2c105b8bfb6983902def2379dfd6b0c8872ef293460"
    sha256 x86_64_linux:   "43cc8b7b220456f0098613659cf7db0c389de3971eb7679e619726cebf486b45"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "lz4"
  depends_on "openssl@1.1"
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
                      "-DWITH_ZLIB=ON",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
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
