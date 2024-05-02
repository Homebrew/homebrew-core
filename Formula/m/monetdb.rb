class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2023-SP2/MonetDB-11.49.7.tar.xz"
  sha256 "94db6d9c8627cbac793663db20368adb2db62fc2675bb8d20695a269305aaa10"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a152349e77a006d596085409734e63638a58104a1aba746a8ab9b3f026959629"
    sha256 arm64_ventura:  "3ad348cf3ac351f2fa9c332c6c140d491f4a1f8e6c1ce84145b27964b98498b5"
    sha256 arm64_monterey: "e5abe19f54aef3d343e5f337fb3828ce0737d2cf01daf7d3c219a5619d5c696f"
    sha256 sonoma:         "9a7735de83a5c469eeff6a5ec32b5c79ebea03f1798462369df37050101080d4"
    sha256 ventura:        "b8c78ed7a05b2e72e6832068cfb0bd062aff4eaf2e17e0a34e4a6ef1a3b812b7"
    sha256 monterey:       "cfd5f49a9b5f99b4400a10e98ed79b0e3388a0b1ae366ab129e1347efeb55808"
    sha256 x86_64_linux:   "85d8116d0817e0c95e3bd9c3f6a27d80ec43d2932fd41c6a3f0d64465b0d56b8"
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
