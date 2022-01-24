class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jan2022/MonetDB-11.43.5.tar.xz"
  sha256 "870ab847298777b0a274ebdda89ac9c53ad99d967d3f9f5cba67e50b633fed1c"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/Latest/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c47194f10b937efa2b057a22f970109e60db4cac5b99bac5a4b11a043228ee7b"
    sha256 arm64_big_sur:  "81575c800a177c23b9331eef5ceece3eaab94d871365293bfbe8f12d1c728721"
    sha256 monterey:       "8e9b479f25719178a5e0bbe097a8f8c77e7efad7d92a28d14984b2a22eefc188"
    sha256 big_sur:        "c2b01158faec5f4f561cc1077853b1cbb8f0c7d9851b06cc74bef7341a929066"
    sha256 catalina:       "a4675e586bf8ddf34197c39c603b3acae8f13beab67130fb91e54c3e95ed8c65"
    sha256 x86_64_linux:   "a37636ba4d3b0cfd60138403d33175efacecf9707a99521d9cad60eb4d784caa"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lz4"
  depends_on "openssl@1.1"
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
                      "-DWITH_ZLIB=ON",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
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
