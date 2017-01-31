class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.4/mongo-c-driver-1.5.4.tar.gz"
  sha256 "8a0f908ac06619d8074acccd2e26443663ba6effbc4326959db6925cedb4aebb"

  bottle do
    cellar :any
    sha256 "cc2fc380ecf4fb5fa11fd7c1cb1793b09ca46f9f158909f41bcfa26f94a7a2f8" => :sierra
    sha256 "e1089aeb29b39c92065971a0f9a82972b94a405e5eec922a86e1d62e7369da72" => :el_capitan
    sha256 "a29d173484f7e07d0ab086db392268c2cae7c27e3cf318807f18f5bce090a1b3" => :yosemite
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?

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
