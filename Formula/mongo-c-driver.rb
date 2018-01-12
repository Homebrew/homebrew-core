class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.9.2/mongo-c-driver-1.9.2.tar.gz"
  sha256 "02218d67ebe7b45476bff9b27a94c78a18b348604148ec818edd81c2133adad2"

  bottle do
    cellar :any
    sha256 "fae23ac34088950f9adfeedbae2b8fdaac01af915ea4aa7e0cfd38e7a5a8c787" => :high_sierra
    sha256 "27e238451be68187ffb51c6f9260ab3f445a3546eadb0f2f39f3e3cb8bc90822" => :sierra
    sha256 "d5697d53c7a92aa3ed786709d28d36c1cd211979d50495067958ac6b8d2cbb3a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "autoreconf", "-fiv"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man-pages
      --with-libbson=bundled
      --enable-ssl=darwin
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"mongoc").install "examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"mongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
