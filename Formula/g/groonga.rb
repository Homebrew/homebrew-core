class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://github.com/groonga/groonga/releases/download/v15.2.0/groonga-15.2.0.tar.gz"
  sha256 "068a5cb0b32352e0c04f1a5a800259ea5bb740800add7c9b786d052e16da7ad9"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0b93b8de437edcf2b3b3124fb29a5b0d787ce564a16d6820b88837a75ac9a687"
    sha256 arm64_sequoia: "fd4e7c1ce563f0102bd6d62a3c3bf6ac89b20174d10a08cdc9e728b291ecc04a"
    sha256 arm64_sonoma:  "064980a90488546ec0d88927c40762a26fb6e045299438d84454e20a6133aa1a"
    sha256 sonoma:        "4da26624de3010e6555b22f8ca179875bf8a66a020f88c1c63eeeacaa7d3dfb7"
    sha256 arm64_linux:   "0d4de21abdbbb51107675eddc7af4ec705d15a56517d0bf27b1cb8f485948c9b"
    sha256 x86_64_linux:  "d94da2b207e533bab701a1c4e3b1d084cd764c760a6e007dc2a813a5aa6a83c1"
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
    url "https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.3.0/groonga-normalizer-mysql-1.3.0.tar.gz"
    sha256 "693c24eff9ba95cd498ba28f8d5826843caec347b5aa6976e565e69535b44147"
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
