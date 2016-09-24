class MongoC < Formula
  desc "Official C driver for MongoDB"
  homepage "https://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.4.0/mongo-c-driver-1.4.0.tar.gz"
  sha256 "2bc6ea7fd8db15250910a7c72da7d959e416000bec2205be86b52d2899f6951b"

  bottle do
    cellar :any
    sha256 "93b8f9fe091383967c0bd85bb4d8e53df1029a7868d1648d1c62ff91e9a0275a" => :el_capitan
    sha256 "af2803233a8d09903469d6233f9a9803ebe9c82ad5ed1d264490c0bee081104e" => :yosemite
    sha256 "738ad530888a91340fc7216310fd929bc869f54f21dbe005d268775ebf8df538" => :mavericks
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended

  conflicts_with "libbson",
                 :because => "mongo-c installs the libbson headers"

  def install
    args = %W[--prefix=#{prefix}]

    # --enable-sasl=no: https://jira.mongodb.org/browse/CDRIVER-447
    args << "--enable-sasl=no" if MacOS.version <= :yosemite

    if build.head?
      system "./autogen.sh"
    end

    if build.with?("openssl")
      args << "--enable-ssl=yes"
    else
      args << "--enable-ssl=no"
    end

    system "./configure", *args
    system "make", "install"
    prefix.install "examples"
  end

  test do
    system ENV.cc, prefix/"examples/mongoc-ping.c",
           "-I#{include}/libmongoc-1.0",
           "-I#{include}/libbson-1.0",
           "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0",
           "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
