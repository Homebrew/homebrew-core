class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v16.0.8/groonga-16.0.8.tar.gz"
  sha256 "cdd27b34f1b8bd3b1b59c2278fd5d6f7cd123d2a9366d23be0a08833b00ec000"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/groonga/groonga.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "516833dd17025751c654704738a6865ccad0275cb15e7d83fca312e133b8485c"
    sha256 arm64_sequoia: "8518397baa1727f8cc5014c92d7b13db5fe0e4eaf38ad82ae0b3e30993d84077"
    sha256 arm64_sonoma:  "dee675420a08fae9d3d26cc5c4f6ce004aa8db300ba4ffb39319b55237713b3f"
    sha256 sonoma:        "17be16345b44cb2dba8dc808003bb20131faed90cabb9c5de57568bf84773078"
    sha256 arm64_linux:   "09d7989c2fe1bd0be3fa60e225de39d1978949398760b08b44335dace735dc79"
    sha256 x86_64_linux:  "c4a6701aa20dc20f7e45f208b1e0eb1332c0855a993b5f865544a607cc3933c3"
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
