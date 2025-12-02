class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Mar2025-SP3/MonetDB-11.53.15.tar.xz"
  sha256 "edc8dd4103eb7526c92f7c19bc1e492fce66ac3b85ab5af313ea8930303e9dc3"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "6c20f972c17ed486d21199f38b128edc387d6c5926e04a7ca65a71702b04a8fb"
    sha256 arm64_sequoia: "2bc945873e1c4f49e13d0fe3ef48ce1a72366b2aa123acd49ea95ec5e7594b5a"
    sha256 arm64_sonoma:  "9cf1f197a788d1a194f3c6fca58c0905f2ec005b6b7fefe8da003e3d86bc70cb"
    sha256 sonoma:        "a98d3fa1141a944f21cd92c7bb3524cfd10b1ba4155bcdd973df4df0f411e6be"
    sha256 arm64_linux:   "fdc79f75f8cb9c8dbea9645ad522d9c8b4ae4af2307e2f7e4880f39163a6332d"
    sha256 x86_64_linux:  "dcb0bd7b450db7c388ddb3bb700f9209d2381114ec3643fb489279eae6bfb534"
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
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
