class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.0/mongo-c-driver-1.5.0.tar.gz"
  sha256 "b9b7514052fe7ec40786d8fc22247890c97d2b322aa38c851bba986654164bd6"

  bottle do
    cellar :any
    sha256 "5efcb632391b92a4c757657109ad33ff2f64229b71e372e6cc0cb009ecc0c983" => :sierra
    sha256 "3a3ee2219d057fc2bf811d206c4ea45d7c761c9d7ded6841d643a2f5660efeda" => :el_capitan
    sha256 "4ea7dddaf58fb7d3f3fe3b43a8bb8dba71fb9e11687db887d6ceb4f3b24ccb86" => :yosemite
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
