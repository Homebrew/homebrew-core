class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.7.0/mongo-c-driver-1.7.0.tar.gz"
  sha256 "48a0dbd44fef2124b51cf501f06be269b1a39452303b880b37473a6030c6e023"

  bottle do
    cellar :any
    sha256 "5b57d5d123d35fca677b791747954d49131f151f3ee95e0fabfcf5b64f5a79de" => :sierra
    sha256 "f2f0d2c74a7c8a53224efa99619b1a7be7c8f22e0a6faebdbbfebab960062314" => :el_capitan
    sha256 "ca8e23a87009f827f36f9644e2e7e4b2e0344d92d5669c379cd6cf219437cdff" => :yosemite
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
