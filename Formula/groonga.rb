class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-6.1.3.tar.gz"
  sha256 "1287b2bc3fe9e65638b7536daecdbf8abbe20411ffc1861229f07c01a9bd2b66"

  bottle do
    sha256 "dfd88f673f10afd1005d54c40055dd103001249e8dd83c858a1bff20c875938a" => :sierra
    sha256 "ab5bcf047a559e5e08f30583feeda704b71834c23110751f8a10b6b9da2f79e3" => :el_capitan
    sha256 "d0bda3fafb65a3276416bd08af6bc0fc02c96eafa66e244fea94d4af46d016a0" => :yosemite
  end

  head do
    url "https://github.com/groonga/groonga.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-glib", "With benchmark program for developer use"
  option "with-zeromq", "With suggest plugin for suggesting"

  deprecated_option "enable-benchmark" => "with-glib"
  deprecated_option "with-benchmark" => "with-glib"
  deprecated_option "with-suggest-plugin" => "with-zeromq"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "openssl"
  depends_on "glib" => :optional
  depends_on "lz4" => :optional
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "zeromq" => :optional
  depends_on "libevent" if build.with? "zeromq"
  depends_on "zstd" => :optional

  resource "groonga-normalizer-mysql" do
    url "http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.1.tar.gz"
    sha256 "bc83d1e5e0f32d4b95e219cb940a7e3f61f0f743abd3bd47c2d436a34e503870"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --with-ssl
      --enable-mruby
      --without-libstemmer
    ]

    if build.with? "zeromq"
      args << "--enable-zeromq"
    else
      args << "--disable-zeromq"
    end

    args << "--enable-benchmark" if build.with? "glib"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"
    args << "--with-zstd" if build.with? "zstd"

    if build.head?
      args << "--with-ruby"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make", "install"

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
