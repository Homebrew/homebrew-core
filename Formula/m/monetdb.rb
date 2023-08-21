class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2023-SP1/MonetDB-11.47.5.tar.xz"
  sha256 "8f9784ba6fe09ac9f38fad4e4524cb54d718728716794fb92e2dd61b6f0b9f78"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f58c7e87cae6e35eced2e318ac19cbf0596d26623a06dee5526bdf04a26f9973"
    sha256 arm64_monterey: "ea9bfde813515d3e101a5ca614e2960bdbf4fc5572757e579e9f586ea27a7287"
    sha256 arm64_big_sur:  "154386fb46557f19d452f79e2db8352845faa76bfaf14f603b2f1bb9a43734dc"
    sha256 ventura:        "7f1d63058df7f03cf737774804a2ee3274f638a8fe80c56883fc76a1ba2c0f6e"
    sha256 monterey:       "182c27176cebd664844991654d83d4d901d0c50e0162b7d985f2604438593b75"
    sha256 big_sur:        "2fef2e1716870fb13b1e698d6d2899fe3012fa3a18c27a54dc03ee0bc28d3b17"
    sha256 x86_64_linux:   "b736d6db314e18d6f554cd3e1e16d9ce0dc6df4a84da95d899ae629a5b67068f"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "lz4"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

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
