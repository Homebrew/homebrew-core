class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-12.0.1.tar.gz"
  sha256 "ed74bfdd173298d6775049f5dcbea7439d940ba4ed6d21d67dd50527aeeef281"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_monterey: "55d9f489d580bb30efaacbd61a12f0a8227279ee27cc6bd557c6157effd37f68"
    sha256 arm64_big_sur:  "ee9bc39b0fb23ba204eb6f231dbfbce11d81934a5a5ad4a4b88801b88aeee0d8"
    sha256 monterey:       "74d3edd66e160b49bfef8d24e4250098bb0f8583f9fdf8af64c24f72a1156f3b"
    sha256 big_sur:        "a7eacbbeba65d0f50e7b84b14c2ca1beafee9c3df3d0db7c5f7b4426a8faf83b"
    sha256 catalina:       "5ba026f8fa4e3b975f2e2d58d8b4e8d646814cb8fb55eabd7db748b327b3d44a"
    sha256 x86_64_linux:   "6e93334fa03e388985e6b46da34a7922dc61429f681d7e2940cb9044e9260df7"
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
