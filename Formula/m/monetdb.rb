class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Mar2025/MonetDB-11.53.3.tar.xz"
  sha256 "23e1f6a73ac721298f9b611f18930b8ceda34c6f497a4e458034b7131660c070"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "92579b5419866811ca88e4ee4d03dac2850756ca79de954dea65c9d859f1b8ee"
    sha256 arm64_sonoma:  "76c21dace99d0c7183e29a23e22347b2bd58d5e0538cab00dd94681ffd68d9c1"
    sha256 arm64_ventura: "ddd6364ddb2ee11232a1d4e166b3fa068a02738fc615378ff6e2b5540a6ec887"
    sha256 sonoma:        "d6066e9bd909f4afa9a98f4230bcdf0c7d62a5aa702d2017877cb4de7fdf986f"
    sha256 ventura:       "f347fb8324a90053e83520a520fcd91995cc8a426a54485d8a9f5140e642760a"
    sha256 arm64_linux:   "493a56abb54f14e25905f9d73fa276af7ca8afd9953c5a236ba513b544b3518b"
    sha256 x86_64_linux:  "9245ff70b7bbfee8da7c1607154aaa930b5d34a4dd89a9216c6f0842b3813d21"
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
