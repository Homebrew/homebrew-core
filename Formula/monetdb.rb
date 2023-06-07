class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Sep2022-SP3/MonetDB-11.45.17.tar.xz"
  sha256 "e2109bb8fe91992086b877154347968d71f96ef0199b09b3a7840c012d39bd20"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "25603d25c661cc86377b54db652afeace622ff7c81bfb2cc0631ab381eaf90d3"
    sha256 arm64_monterey: "f3fc4301330fef621d6f9f7e22cf41d5963cb7d1682d749203f8a7ae4ba34333"
    sha256 arm64_big_sur:  "fd116989aad462f3034c654717dc6c66531facfe5ccd68a192ab5fed3272c1d6"
    sha256 ventura:        "7c11dfffe9258031cc8a5468af607759b5193c771819bb565fe670d4af8ad678"
    sha256 monterey:       "eefa2cc0589cc1e0047535476cb6b860cd6e826f818de985e49e61164a808cf0"
    sha256 big_sur:        "0157db54de5801bbf3134393c1be15dea81adff6aea6474d1bbf78355466f9ea"
    sha256 x86_64_linux:   "a238a003ad24282e5ed22d1ef47ed6722911703268afaa7511ffe30d023b4205"
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
