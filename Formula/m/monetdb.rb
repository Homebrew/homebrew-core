class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Mar2025-SP2/MonetDB-11.53.13.tar.xz"
  sha256 "ed5093234689d7f0ed5a439bc904388f5b2bd12ad08308cedcbd5faca95e0325"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "4449d87247772a1fd6c2081a9a3b865ca0d8c085ca0af48d4faa21b73bc4f125"
    sha256 arm64_sequoia: "7af914168935ca8b325c33eb58212594170a69761e5282be1fc7b5a700227830"
    sha256 arm64_sonoma:  "a2d8e290f5382a6d1f77b21e2311b1d0f25977dc2ae5780cc90deac84a35afd4"
    sha256 arm64_ventura: "d2f0274260282b8604a2d776ba6922a53b203c3648a0a20106b9b140f8f0b4b7"
    sha256 sonoma:        "543284f5886cb213fa2b545d646f2128e728c43f662556ac29e0ccfbd4cb1f0f"
    sha256 ventura:       "2161d807f5dab1529fa17e7e5fdbf45a2498226f1f6905a8124c3f0ac317ab4b"
    sha256 arm64_linux:   "a82e58f44d85248b85139139daf636c16033665633987d30890088d4882e3828"
    sha256 x86_64_linux:  "c76634658aea72d40f17b6f08273bb2429d1db65c6dc3293926486230dbfb7bb"
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
