class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v13.0.8/groonga-13.0.8.tar.gz"
  sha256 "8caf9cbb3411200f52b388fb9f47b63af0b205e4a1bcd773fe5d21cfde76c566"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sonoma:   "3bd1854e661964993c35b7a19b994092cb9e2ff66ce90ba94ff8986bac0f02e2"
    sha256 arm64_ventura:  "88da1468d15a01f6bdc8a38b54c06900a3f7c43afd7243c11a7a601f0ab7971f"
    sha256 arm64_monterey: "d594a6ac13d1ec271ac90e07a5e0ba0d6227bf10dc6cc75ab67d258b7e5f03e5"
    sha256 sonoma:         "2e1f46728f598f4008bfe2e6a8f6cbb24a0ce49e737eeb1c358ac43962af13c5"
    sha256 ventura:        "3df0122f64866d494708b34f23f024e068b2016e7abaa18a712d308cdcd12f94"
    sha256 monterey:       "3065b30f77f8e9b086392073ac96192d0e5034eafc2841656135cf2e30c50ef7"
    sha256 x86_64_linux:   "a374956d04d8ea2283a6b1aeebcc85bc1d74ff21342530ac901041ae122c869e"
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
