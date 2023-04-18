class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-13.0.1.tar.gz"
  sha256 "1c2d1a6981c1ad3f02a11aff202b15ba30cb1c6147f1fa9195b519a2b728f8ba"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_ventura:  "2d2e2ced3d7bfb99541d05ddba5c935a08af3d332195235b95bb5d91c5f3e2da"
    sha256 arm64_monterey: "985c4d3038c932727374d52e6ac7878c665776717c296bb418a1f3fa97b2d21a"
    sha256 arm64_big_sur:  "2129eb13dc82d031f0e24d49729f005f6b47817748adab6b4af46e956c6505c5"
    sha256 ventura:        "1781fbd25a952c6c202256ea13a8cfa99188c6da80f2d4adca42276dee0f5241"
    sha256 monterey:       "3bd06f323501689aab8b8e0f8dde30c25a44ab5df1bda007ed2879ab0c8b7c77"
    sha256 big_sur:        "0d77bc5e64d0a1ea5fc5a3a7e70a23d0755d4b5bca00aa3d75dd706d752a714a"
    sha256 x86_64_linux:   "40f50140e933bdd52467891ec1ffc59e4dfb70f979f36bcb620d0cbe3275a1ac"
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
