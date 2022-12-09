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
    sha256 arm64_ventura:  "8b6ef089c9fcd9693f9265d9aeaab08fbbd894f9bc5b1a275aaa12f1bd31053d"
    sha256 arm64_monterey: "10c4b08ae59991ce808feff4fb88210396ac80d92dc859104c9857b1d814d98e"
    sha256 arm64_big_sur:  "9e08d1f8d71afa11eca9aa2556068ab50852f76440950a0cf19517e8f5a6962c"
    sha256 ventura:        "f0f4f1a5493f14a390c9bdbcea80f0c1f91ab2b72ed286be6477f911139b6d5c"
    sha256 monterey:       "56b5f2c947286c843ce9f2592a0b1cffbfdad964665777f0f5ac2e910f0fbd29"
    sha256 big_sur:        "3ceea0311e182c56ed047b5ca461163dacbd2cfa6427dabebb2022da6a72935b"
    sha256 catalina:       "74eacef45f9f0458eba07b4e8b1023c9ce5b01ac6959853b90792c9e986d146c"
    sha256 x86_64_linux:   "359f7f846d2f375661b4ece67c706e628861128206987863153a88b47a9e0850"
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
