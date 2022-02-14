class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jan2022-SP1/MonetDB-11.43.9.tar.xz"
  sha256 "19b01e195e4323b6cee7aafae7aebe7226153f9b11dc96f1d97fbd6f0b8a8ef4"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/Latest/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b3d0cb83472f98c6428c96282fa73158fb002c53860bf6acd073aefe21663e13"
    sha256 arm64_big_sur:  "e4893781a9887a5e1cc566c6b1712b44cb6e34d4eb425d7a0de60634d91126d1"
    sha256 monterey:       "62d5ea034d4b02a1d63e45f47988f2db91355fafaba684157b2d3a5f6857321a"
    sha256 big_sur:        "d30423b9d681e51e55617488e3dbbc6df93bd934661d9d76e70b35e37a5c4668"
    sha256 catalina:       "1076425149430f540034e1f8c02ab825c42e18436481dab32146586658c18466"
    sha256 x86_64_linux:   "7d7b93bdcd5ab656ba6c97daccbcc3804fb8705a31fdc47daaf30cbc39aa462e"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
