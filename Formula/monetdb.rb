class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Sep2022-SP2/MonetDB-11.45.13.tar.xz"
  sha256 "1ade44980747ad0e3ea787683ca26a95304bdb299ba64040b152eea5671d2f42"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "348e1c9bccbba57c8f4f2def5ac5b5b00e593281f644008475fc92a6237b46bf"
    sha256 arm64_monterey: "4b35171923579ba256003d1e27b22db05a5c74c7673ef7d64472b2a67e402322"
    sha256 arm64_big_sur:  "28c4a39953086dc65eb7f4badc94386759fe00eb953b4b0e7cb28ffbc50ec050"
    sha256 ventura:        "d60fd2369e04ba550622c842e7018e7b7f56efa89fae670874503c3b5326a4bc"
    sha256 monterey:       "fea4f069d3855283cf3dd1e9fc5c99dd6d5885718f350425004c2380557ed0d5"
    sha256 big_sur:        "a1b5731ecc180dbbafde6e8f417bc0f846b7be887d8e5fab2b6b9c44fc7ed304"
    sha256 x86_64_linux:   "9ed260bfb2899f7475e88e12bf6f04ceb14071b26f2fab8103f6e7b49891928e"
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
