class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Sep2022/MonetDB-11.45.7.tar.xz"
  sha256 "3707897bb84ecbb73b196bed06a017a7f8a9f50bc8cfca87eb496e87d9254a0e"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "56c8aeb7a8ee4c7e1b99d67a0e96c53f56fe3d5c48831fa992d9421652eeb73a"
    sha256 arm64_big_sur:  "177fc4fc6b39869dbaaa945cd103ca2a2fb7243b0c80e2d5028cc8317ef129dd"
    sha256 monterey:       "85514474d20b9d8a4cc3dd1f368065dbce587eafe76f9fa6d9c2e97743a55400"
    sha256 big_sur:        "fe49d4cfdb90ffd4cc623d8ee6e8f0cf5cee145d1d42d05432fc3232ad9298b9"
    sha256 catalina:       "82a32f55f20c4c15156699d0cef3bf8856d3ee3405e5fd985188f53ca0660245"
    sha256 x86_64_linux:   "2945dda661cfb58943d47467317d3b04cfeaf2438e2173bf3efe442fea5594a2"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
