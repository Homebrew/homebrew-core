class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-6.0.4.tar.gz"
  sha256 "2c6ebe7e5b1065b777cbc5c6696a47a2b7da510b4c3e785f45437a56ad65ad58"

  bottle do
    sha256 "2dcdfde6f5b80573078c11e81b24a131581523b0dde68d4c47ccc94aec9c664f" => :el_capitan
    sha256 "b4d4903ceddd5ab657b03b798ef12696b5ab35876c2eb41663dcd8536986aa9f" => :yosemite
    sha256 "9da034e0d2925b9c904dd9788253e05d974c5c5b56f0c225a7f027990947384b" => :mavericks
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
