class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-12.0.4.tar.gz"
  sha256 "baf0b9c5c46b015fa2c1ea34e17d55f184e06dea89d36aa5ada1a8fcd34680db"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_monterey: "a37927dfc3e49d14da945fa8a1bbf877b258fc347ed3149de2f3c14afbf43c00"
    sha256 arm64_big_sur:  "09dbda192f4c04e811a412d35ad8422fc26c639d816925fd14bb7450c9071761"
    sha256 monterey:       "657269b5e2a371f9f27a7dc69d78681f6362639e91ed72d8f43de4e072692cad"
    sha256 big_sur:        "b6482dc07f66fc9868d7e28f4786feb647080da666af3da0ca9e46f335dda47c"
    sha256 catalina:       "aa3e98c04fb9f624590d2dbf788673aef79e4b490dbe2334a28c0c21aa3b37b6"
    sha256 x86_64_linux:   "ca81abe1a0c0dce01aa989f01469a94e5dab37bafb807843f11b1168345bccab"
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
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.8.tar.gz"
    sha256 "0ed23e0c0b4d4dca23c57bbd98fe3d051c3f3ddacbbe55d07fddb6c53142cae5"
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
