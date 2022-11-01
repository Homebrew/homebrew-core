class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-12.0.9.tar.gz"
  sha256 "ecb10a9fb3adec276dd3864da97ecea13c432e9a8fe827b6d3c82b49c4df0c10"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_ventura:  "af2020208e8a552bf040d8cf2f3606aabd9b9d79ae29c7fcf8b21a6e857d69de"
    sha256 arm64_monterey: "1421f70a675e9231aba9a9a4cde0ef926940c2e5b464a5f89dce771f4e375618"
    sha256 arm64_big_sur:  "c8989770e372ad6d45e78d86585ca93a6ec4a57994d87db6d453dd951fac3946"
    sha256 monterey:       "77cc8db9f69558ec4dc170db178245be2c6d1da9cf14cb388222147a5285124e"
    sha256 big_sur:        "80ae5dc841c843a2fad0d2d222d93e33a57022a5672b6827748b0f62714eacb5"
    sha256 catalina:       "6780406da4318664f19a31ca5c089315d7b47c6f6ecbdf246b79f9d633d8479c"
    sha256 x86_64_linux:   "cdab76a16aa54c6fd197054ddf7b648b7092c0b19b5909856f7a4d3c55588076"
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
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.9.tar.gz"
    sha256 "5e70fa226c7469094bc625829b990dfe6d482f8f1110d7177d3594296dd1632d"
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
