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
    sha256 arm64_ventura:  "7a12dcd22694cd438453f56d50b7d3025122eafcd1fd682cafea500d151273ed"
    sha256 arm64_monterey: "c004b7d0300bb5850b6e4562268b81f13bf39d76efbcdc094feb2e00756afae6"
    sha256 arm64_big_sur:  "bbde105a403b22080d7aeb57e6a2abbe64326a6296441088fdda4e9a89c9e204"
    sha256 ventura:        "94b2c78d89ace4faba3f3ed524499bca3c6c1913eee20bbb69d626cb04d7d0e7"
    sha256 monterey:       "683bc454a148290d20ca5ff08bf621fc820f217d88ec684088e9041c01d340d4"
    sha256 big_sur:        "d290c53f2814f2b770ad69248f6d536512668241d2c87b2954cd4fa97532659c"
    sha256 catalina:       "e13b0a3b3ec9e8173033ad58e05e01545557984240a2ad68a83b3a8d902517bf"
    sha256 x86_64_linux:   "70eb0ef7e31935417a4dfcab7b052e28ea6c0af5417b3ce7303bd641513387b3"
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
