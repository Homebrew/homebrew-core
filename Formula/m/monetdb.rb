class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Dec2023-SP4/MonetDB-11.49.11.tar.xz"
  sha256 "f7f8aa8cf641f79f92a269dfe4bc4dadb11a0c3bba49697e5d48f5c9e13a2157"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "57e0541cad95c85cc6f3a17c1e3cb18efeff35d7b19d5d232f1b1f121f855b13"
    sha256 arm64_ventura:  "695ed53fffd60368fc01b9cd15780d4b3aa9856717648723e21dd7246dc2a279"
    sha256 arm64_monterey: "a1659635e58d9d7eec12d79fe7f12cc46ef6fc8c9cf264469a27c10425b9a781"
    sha256 sonoma:         "a3faef64c3737442c80a04a3508eecba77d84df97d4ba4d32e2ca9448eb65416"
    sha256 ventura:        "ff1f7c06784cc1e1dcd42cb2cebde1f5f9c685edb18b3ffaa3a8e9f9c4d4a060"
    sha256 monterey:       "7e430782f40f1877b25da7b75584513780174901fc1a62549f528568c83fa412"
    sha256 x86_64_linux:   "23fe6c31afa1549ef809461ccdee67b9a132a0783aea98c7d298aebb363a256d"
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
