class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2024/MonetDB-11.51.3.tar.xz"
  sha256 "2f4499349e7917e12ec5d2d33d477bb50b4a302485cfcce1ca20129c7e791264"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "96f96cb48088cdaa3c868a453c9b298538f4cb049035041a569d02afe51fe682"
    sha256 arm64_sonoma:   "e0614266a5bec3fb9cb384151619f90cd029069a8ad1a2e7218db2fe31c56d26"
    sha256 arm64_ventura:  "65981cd668538e4b9d79a8cd6297594a8c65e8cac03358d86e56620691cabbe7"
    sha256 arm64_monterey: "854708fc0d738d4d4bb4e8a18b0b1e6febcf81b3643a9f83a7e423d6ab39958d"
    sha256 sonoma:         "7d67c99b5bc5ecb03c06f0d96af1119730e7ce0c4e84a9a213da3ac1b330b187"
    sha256 ventura:        "61fd24dc0a7e50526d29dc28a642904827ad1cc921c6ebbd1c1c52fe0bfc0ca8"
    sha256 monterey:       "f3e27bb257cbe9f74b7564c9b2d17b26847ec588f702de6249786c9ad42a3ed8"
    sha256 x86_64_linux:   "70f646cdad185a3ffebc909386b43fb2035e4ee81e7c03ff1ce3ae6ac4470f05"
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
