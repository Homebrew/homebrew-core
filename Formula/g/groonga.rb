class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v14.0.2/groonga-14.0.2.tar.gz"
  sha256 "a3d0ba94f38f91bd8a09b1780aa2f22ad5c77ce741de3008bf93fa4a34c90097"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d0ec626d99d16195167ce4300553913c06e880b3be01eeb13c7ba6775ebfa039"
    sha256 arm64_ventura:  "462ed9ac89447742d4d4d75cd21f91a62f5679dc6f2c3842732ca08a23f5a379"
    sha256 arm64_monterey: "fd9d5430b932f251ad4ddc5b67f7c4583a71e570b1e3a14e77972ea224530263"
    sha256 sonoma:         "bca241abf271a3fa48a6517289e27259672e14a3e1731b3a467a7706f6ba02f3"
    sha256 ventura:        "99d94ddcb431032c5e8048d8540decba356380056198c23346ce28dce4f8e8d4"
    sha256 monterey:       "0c480905b3abb0c05fce8ca6bbead6c6abf5faf20ee414a301d9a3ec99415104"
    sha256 x86_64_linux:   "2e2206a222c279b82e08db192a9fb069099a28ab1bd357351007c194b09c8ffe"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@3"

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
