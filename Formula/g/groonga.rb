class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v15.1.5/groonga-15.1.5.tar.gz"
  sha256 "7513bd4014022152651613598d5670a221087ac201ae46563523b0ce090e9e46"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5295469fb2b571bcbbd5a6cf8422b744592b84b061dbb0713a0114ff352243bf"
    sha256 arm64_sequoia: "510337108f4c4f1b06586a1d23d9e66ef962b478b8b0f41fb4266bf65e9104e1"
    sha256 arm64_sonoma:  "1c6b89aa9624d6572e2081e9a74b72988a26e6bff4bf87f91041a4a03a2c89ae"
    sha256 arm64_ventura: "b5c20c01a0bf0fd123942e002878d8706444d9eec6249356a1b8aef97343098c"
    sha256 sonoma:        "5759778aa17537e334b2453ec8f30d07d7d6f4f9d5f37eb58c669909342b4b40"
    sha256 ventura:       "ddfa65d9151b0c8e8851f729d7889941979d62745f377f7d25b18be6fc7c1f79"
    sha256 arm64_linux:   "7143ee23bfe3145d244c4d98364e5c65de5e91e8bb13541bc558afee823d7cc5"
    sha256 x86_64_linux:  "8f49e61904a02f124e968e8a7c14db6411ddeea8225735dde10bdd5d287e7abf"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.2.6/groonga-normalizer-mysql-1.2.6.tar.gz"
    sha256 "f85b49d24f4f4559cb1c0479dcb945a6fa0571390f40aeff38bff8e8f5e84157"
  end

  def install
    args = %w[
      --disable-zeromq
      --disable-apache-arrow
      --with-luajit=no
      --with-ssl
      --with-zlib
      --without-libstemmer
      --with-mecab
    ]

    system "./autogen.sh" if build.head?

    mkdir "builddir" do
      system "../configure", *args, *std_configure_args
      system "make", "install"
    end

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
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
