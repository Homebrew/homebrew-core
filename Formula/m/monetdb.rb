class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2025-SP4/MonetDB-11.55.9.tar.xz"
  sha256 "c2edb5a930fc0c5aaf7fe1cac34be2bb125a1e52ee5fbdf1df9a993cc526cffe"
  license "MPL-2.0"
  head "https://www.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 arm64_golden_gate: "a38076d26c183ace8585540a0a48f70ebe3e15d00f82c8faaf9bed863ab62d00"
    sha256 arm64_tahoe:       "44850ce0266da93c34d4a2a6538ec064d11bd0a75a53cf6fe2036ad068cc6ef4"
    sha256 arm64_sequoia:     "f69d78a3b0e54962c7097587701e6673f57666350e6df11d77d049cf166b425e"
    sha256 arm64_linux:       "6adf4506a21a461ad1d017021860f9dc8bc7627560e7949202598d2837296cd5"
    sha256 x86_64_linux:      "c57093954a6ced9836f855da5110ded87e71028268cbe6f131b41a9ee39abcf0"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      -DRELEASE_VERSION=ON
      -DASSERT=OFF
      -DSTRICT=OFF
      -DTESTING=OFF
      -DFITS=OFF
      -DGEOM=OFF
      -DNETCDF=OFF
      -DODBC=OFF
      -DPY3INTEGRATION=OFF
      -DRINTEGRATION=OFF
      -DSHP=OFF
      -DWITH_BZ2=ON
      -DWITH_CMOCKA=OFF
      -DWITH_CURL=ON
      -DWITH_LZ4=ON
      -DWITH_LZMA=ON
      -DWITH_OPENSSL=ON
      -DWITH_PCRE=ON
      -DWITH_PROJ=OFF
      -DWITH_RTREE=OFF
      -DWITH_SQLPARSE=OFF
      -DWITH_VALGRIND=OFF
      -DWITH_XML2=ON
      -DWITH_ZLIB=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
