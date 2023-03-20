class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-13.0.0.tar.gz"
  sha256 "5c59bec3eb04eb77051b956ddde3411d3be25175cd39a4f952ff46596ca14632"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_ventura:  "ae08e73d1a04391f6c29ef7dacaea7b4feddd8b3581c2990d550fc78dead2827"
    sha256 arm64_monterey: "7e247b6955c4b8f4fb9e3f3ae538d0286ffb265c0d21214def84694e8ce621eb"
    sha256 arm64_big_sur:  "b2c2236a8197e513bfc114e26584cc2b4de447686015194169945f3fefc29eac"
    sha256 ventura:        "32491f40ccc9cc6177f1270951cfc9065928cb6e481c1969d742b327c3ec54f2"
    sha256 monterey:       "404bf81fe9e74a0ce20c0842e494a92922fa89851983758e532b83de200f6d0b"
    sha256 big_sur:        "e834e8ffe165e71b64c5feefb56f8662bd666080dc0852980b4ba8a56e7e4c21"
    sha256 x86_64_linux:   "d46f10219807ad48de1fc90e9bb8937cfbf1e411fd43b52617c48ec399536f82"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "glib"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.2.1.tar.gz"
    sha256 "c8d65bfaf45ea56326e4fec24a1e3818fef9652b2ab3a2ad9b528b7a1a00c0cc"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-zeromq
      --disable-apache-arrow
      --enable-mruby
      --with-luajit=no
      --with-ssl
      --with-zlib
      --without-libstemmer
      --with-mecab
    ]

    # Temporary workaround for `msgpack` rename. Remove when resolved:
    # https://github.com/groonga/groonga/issues/1536
    args << "--with-message-pack=#{Formula["msgpack"].opt_prefix}"

    if build.head?
      args << "--with-ruby"
      system "./autogen.sh"
    end

    mkdir "builddir" do
      system "../configure", *args
      system "make", "install"
    end

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
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
