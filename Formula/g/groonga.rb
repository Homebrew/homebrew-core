class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v13.0.7/groonga-13.0.7.tar.gz"
  sha256 "817adbd4942f524557e479b2dbc3cfd181683deff2dff8d9db85fb621a518eed"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2d007b743526d7a7a1e371a2a589da0e1136514ad8d6729a8f581e514843956f"
    sha256 arm64_ventura:  "c71d6b1b73a357769fec1e2b4838991c233cd9fcd6443daf90b8ec6ae5d9f1e6"
    sha256 arm64_monterey: "dd1676ca9819bb8c5f49e0da5036e74948039f14aa4be341929a84d4c31a74c1"
    sha256 arm64_big_sur:  "d77191491fe6917007d8bb0d5c738ba1612e3dbe029b79517efa5dea1201d121"
    sha256 sonoma:         "e61a721be605e11321df212fa4768dc910602d638261aa327e77970f06136ca6"
    sha256 ventura:        "03c72b7ed0f7ff1deda24cae36d2c8478ce4a44a50d160d269fdf5d969d4d058"
    sha256 monterey:       "24a469661b6dcae18a92e0583b01c2b0b54e43a22573680d56ade6aa3a8117b2"
    sha256 big_sur:        "c0efa4df8546b9904d8e24d2c906ed2aa86d2fedc9dcffb89b75d3bc03cc94e6"
    sha256 x86_64_linux:   "22a38701fc448ab2b62b84650ce6bc6af1f511d10efb47dae3a5ee4d7303803e"
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
  depends_on "openssl@3"
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
