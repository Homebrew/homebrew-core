class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2025-SP1/MonetDB-11.55.3.tar.xz"
  sha256 "9592aa0fb18aeb22ceb6a4f9b60cd7960362832704e3625a025673e89e861a51"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 arm64_tahoe:   "7c3536841c412cfa0564540cf569935c9f4d93cff2d85f82c7f7c89398a83ed5"
    sha256 arm64_sequoia: "dda5c447aea4bba4d87909d719fe9ac8afc147e76ded673b820f9201776b150a"
    sha256 arm64_sonoma:  "71254a64a8b98c14ae26bf322263af2a8baaaa85efbd8fbfa16b2e5542a90fdc"
    sha256 sonoma:        "d2414b833b2874a2bc8224d97561e4fe68b89811d7e7b807b99ed944faeb9fa4"
    sha256 arm64_linux:   "d247bbffc4afc7e931a9354938e2b3ff9168aa9c5b70333df1d4e221855730a3"
    sha256 x86_64_linux:  "447f37b30a3e92f8886a1c80eda479ae058519fe1c47b457e3a8a444f6eeea71"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
                    "-DWITH_RTREE=OFF",
                    "-DWITH_SQLPARSE=OFF",
                    "-DWITH_VALGRIND=OFF",
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
