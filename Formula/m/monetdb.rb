class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2025/MonetDB-11.55.1.tar.xz"
  sha256 "a5848beef0908ee5b4477beb66a9fa72ee1ab8d5bb4eec5cafcc3fa9dc32b299"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "51d0f59f90fbcb28e4cbcf00c99edd006ce26942d60c7b227796950147b7ed23"
    sha256 arm64_sequoia: "937745c337beaa66a5a62e0942aa6b403fb9843ee30fc8e8bfbaf7ff41f20bda"
    sha256 arm64_sonoma:  "af7769cad6a4c6d091ff77645a0b33b6ca7f8b57572adc5382109428fa67b3c4"
    sha256 sonoma:        "9ffa4e89794322f870d9473518c5e30b0acd597e992eedb4acbc8d3d550dfd0d"
    sha256 arm64_linux:   "10ec3661bdb73a27d6f256e98c7f7b3eb99a17dcbf74476e17263cd510e966cd"
    sha256 x86_64_linux:  "729a62e14b6b9e1e6bc0b2cf629183b7712ba0882eca9f0565189975531b27d7"
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
