class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2023-SP2/MonetDB-11.47.11.tar.xz"
  sha256 "1f3877baacb7af87366df1085528a4f0fe8e412c16dc1951374c3111a0c9497a"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "41280e9af8eddf9ca545efce8b66d7abf4602a95f2c40c4a6dc7e535f716ea5a"
    sha256 arm64_ventura:  "bd660b531f3fb0b6437dfa760327e4061c508b9233cce743f77044954a5c0fbe"
    sha256 arm64_monterey: "c7758a7c13203c3dca6cb7f837d79ef9ee04bc6089a8a064ed28fb4e60c938de"
    sha256 sonoma:         "39e39399a4f4516b386a0bd26f7e3fe6809430d9cc499ba6980f4d234097b756"
    sha256 ventura:        "50edd1527c548d414c77fff39bea53a875ef413df48a412d255d316a3b120054"
    sha256 monterey:       "cd13df93206f5609ed2ccadf8d24551e6b70e1140d7c05e7864c667df7c0fea4"
    sha256 x86_64_linux:   "bd60b962b68546e4556525963a5e45d4ea6554f1efdd9158371886430afa961f"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
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
