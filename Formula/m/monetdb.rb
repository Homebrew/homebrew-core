class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2023-SP3/MonetDB-11.49.9.tar.xz"
  sha256 "a07b5ed4586792d5de16989a4299cc46878faaae597595f2db45339a3eeb3fff"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4a0a7a1508dac4817a3e750ce410c5314384ee4409f5cbdfe0d0153dda64c7ad"
    sha256 arm64_ventura:  "747128833da2bdcd035a58975e8e30e3a0b10499a686ccf95f8f7e7ad7d6f5ef"
    sha256 arm64_monterey: "58b624efe3f646cd308319d83460d27ed2cd74c086dadd6ba5f96440208e309f"
    sha256 sonoma:         "c461413763a26353aecc0f279c44aba4e4f01bb1e69d9f527f72fa27b54b3fdd"
    sha256 ventura:        "40332888720e4ba67d459592df1ca35dbfee40e2a39a8fc9ea8ab8a45ecd1b25"
    sha256 monterey:       "bd388bfef5c3d709c352092185acb7e3f99e096ce1b892873759ca77f249ef0d"
    sha256 x86_64_linux:   "facb29564caf2796add43e1d1c0281577e4447450525a507b0a96a66b8c22997"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build

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
                      "-DWITH_OPENSSL=ON",
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
