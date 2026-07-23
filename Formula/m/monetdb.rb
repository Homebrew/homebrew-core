class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2025-SP2/MonetDB-11.55.5.tar.xz"
  sha256 "480c921a45b54c610dee9a17147f0e89ae74c31516b9250e5c8f2371e1bd70c2"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 arm64_tahoe:   "24fc287de47a1464c727526f6e6a78c710b40794b490cacc507c5144e87c87ac"
    sha256 arm64_sequoia: "cee5a44056bb7418286a78bf5491f0896c2fbd3efc7728a1ec4af9b90f1d20d5"
    sha256 arm64_sonoma:  "6b8d075897e6f4e8953a1c63404c1dc2197b4485149b650d5548404a00fcd983"
    sha256 sonoma:        "77465e90ccd2eaba2d244bab4e751317a8239128790a33f82cac87292851bd11"
    sha256 arm64_linux:   "149c74d0bc2b77d5253befcd18a54dc88d6c9e85309665ec1ccc94a58149771b"
    sha256 x86_64_linux:  "d8ccc09b9a6352cdf22dba1f563499cd81c889810e2040908136d4d043f86690"
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
