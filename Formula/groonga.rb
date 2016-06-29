class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-6.0.5.tar.gz"
  sha256 "a3323b5abea048483257a96611477921e3e342690a26f260feb340a3e97a1438"

  bottle do
    sha256 "acfdc4b3017b4e50ca46b994f078f45f12a15013705de4bc01ef11b450f91039" => :el_capitan
    sha256 "02e4d360175087c14c3379901b40b1ebe1d426c29b824dc83cb22ae9ca2308d7" => :yosemite
    sha256 "1d6ddf672cd3738a17302acdb23d40b3a7069d03c6a046d08038a8c3a0ff7143" => :mavericks
  end

  head do
    url "https://github.com/groonga/groonga.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-benchmark", "With benchmark program for developer use"
  option "with-suggest-plugin", "With suggest plugin for suggesting"

  deprecated_option "enable-benchmark" => "with-benchmark"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "lz4" => :optional
  depends_on "openssl"
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "glib" if build.with? "benchmark"

  if build.with? "suggest-plugin"
    depends_on "libevent"
    depends_on "zeromq"
  end

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

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    if build.with? "suggest-plugin"
      args << "--enable-zeromq"
    else
      args << "--disable-zeromq"
    end

    args << "--enable-benchmark" if build.with? "benchmark"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"

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
