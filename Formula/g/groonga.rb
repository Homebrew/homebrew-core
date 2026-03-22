class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v16.0.0/groonga-16.0.0.tar.gz"
  sha256 "e8cec40d59c848617912d988c69ca67445c19fd2d8fcb5b6080eded2df89d545"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/groonga/groonga.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "626682cf7d97df6dec60b9d55a9e61b0a665b5b2134df7ba3ddf057be15df071"
    sha256 arm64_sequoia: "682e18de7a6f5d93fa3c5ff25178c4a35eeb70836cfa96f5c460691f118343f3"
    sha256 arm64_sonoma:  "2e1b8061bc1bcc88bd310bb14ed4ceb381ca0fff31aa803b46f87c67f1a6a488"
    sha256 sonoma:        "bdcdf72f351393971f821fa6a5217909f801d2c50495559511a31cc6707022ba"
    sha256 arm64_linux:   "2ef4cf7954bfbd2124a8e8c146ad03ab9f1f0ff910be298926727bd2d8f53934"
    sha256 x86_64_linux:  "413b8da5a3c5ab73afdbb94cfd0864675b601138805f6eb2d7aa733fc6e1aefe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "mecab"
  depends_on "mecab-ipadic" => :no_linkage
  depends_on "msgpack"
  depends_on "onigmo"
  depends_on "simdjson"
  depends_on "zstd"

  uses_from_macos "libedit"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.3.0/groonga-normalizer-mysql-1.3.0.tar.gz"
    sha256 "693c24eff9ba95cd498ba28f8d5826843caec347b5aa6976e565e69535b44147"

    livecheck do
      url :url
    end
  end

  def install
    # Removed bundled libraries but keep files needed by build scripts even when unused
    rm_r(Dir["vendor/*"] - ["vendor/CMakeLists.txt", "vendor/mecab", "vendor/mruby", "vendor/plugins"])

    # Explicitly disable features to avoid opportunistic linkage from superenv CMAKE_PREFIX_PATH.
    # Also set FETCHCONTENT_FULLY_DISCONNECTED=ON to avoid fallback to fetching bundled copies.
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"groonga/plugins/functions")}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DGRN_WITH_BASE64=no
      -DGRN_WITH_BUNDLED_ONIGMO=OFF
      -DGRN_WITH_CURL=no
      -DGRN_WITH_FAISS=no
      -DGRN_WITH_H3=no
      -DGRN_WITH_KYTEA=no
      -DGRN_WITH_LIBEDIT=system
      -DGRN_WITH_LLAMA_CPP=no
      -DGRN_WITH_LIBSTEMMER=no
      -DGRN_WITH_LZ4=system
      -DGRN_WITH_MECAB=yes
      -DGRN_WITH_MESSAGE_PACK=system
      -DGRN_WITH_SIMDJSON=system
      -DGRN_WITH_XSIMD=no
      -DGRN_WITH_XXHASH=no
      -DGRN_WITH_ZEROMQ=no
      -DGRN_WITH_ZLIB=yes
      -DGRN_WITH_ZSTD=system
      -DGroongalz4_FIND_QUIETLY=ON
    ]

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("groonga-normalizer-mysql").stage do
      args = ["-DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"groonga/plugins/normalizers")}"]

      system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end
  end

  test do
    IO.popen("#{bin}/groonga -n #{testpath}/test.db", "r+") do |io|
      io.puts("table_create --name TestTable --flags TABLE_HASH_KEY --key_type ShortText")
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end

    IO.popen("#{bin}/groonga -n #{testpath}/test-normalizer-mysql.db", "r+") do |io|
      io.puts "register normalizers/mysql"
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end
  end
end
