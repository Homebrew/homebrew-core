class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v16.1.5/groonga-16.1.5.tar.gz"
  sha256 "f7ae843e80aec4a8b83743b570c0f82ffe44939405db0843f06ecd6190801476"
  license "LGPL-2.1-or-later"
  revision 4
  compatibility_version 1
  head "https://github.com/groonga/groonga.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    manifest_sha256 "54279c369e9ca00fe8701c8a3b6d30bf830ad101987b6468dafa78d906a86e22"
    sha256 arm64_golden_gate: "2b200f46ef6dd170af1822c607733a56e79174dd7ea847fe3b1f78510fcc79dc"
    sha256 arm64_tahoe:       "cf426d2e26cdf23c68201fcc861b7896144d31787c32d3b60715efaaef7420de"
    sha256 arm64_sequoia:     "8bfe9a861ad6b065a3a694b5118a38ff9724dc12c2a17448cde576ecc1e667eb"
    sha256 arm64_linux:       "990892c10849ad74147cc591d77438e06c4c5a69c0cd39c6bd7157d293809fc0"
    sha256 x86_64_linux:      "aace0a72a96355785eb170866f14d0118493120c8f1d3f88bcbdd05ec4f00a1b"
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
    functions_rpath = rpath(source: lib/"groonga/plugins/functions")
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_RPATH=#{rpath};#{functions_rpath}
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
      normalizers_rpath = rpath(source: lib/"groonga/plugins/normalizers")
      args = ["-DCMAKE_INSTALL_RPATH=#{normalizers_rpath}"]

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
