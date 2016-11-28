class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.0/mongo-c-driver-1.5.0.tar.gz"
  sha256 "b9b7514052fe7ec40786d8fc22247890c97d2b322aa38c851bba986654164bd6"

  bottle do
    cellar :any
    sha256 "1e3697dc3b2725914b720cb2aff628d1abeccfd26fc74ebe24bf3be83a5b5ba3" => :sierra
    sha256 "f53836a2f6179cc4e65f6ef78c5a71792f9bd319676e9e8ef06d8fa5b4fafc5e" => :el_capitan
    sha256 "c9fce4411ff385d090dc9e20529a045fa98b91801edba2732015f674fa581763" => :yosemite
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libbson"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man-pages
    ]

    if build.with?("openssl")
      args << "--enable-ssl=yes"
    else
      args << "--enable-ssl=no"
    end

    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples"
  end


  test do
    libbson = Formula["libbson"]
    system ENV.cc, pkgshare/"examples/mongoc-ping.c",
           "-I#{include}/libmongoc-1.0",
           "-I#{libbson.include}/libbson-1.0",
           "-L#{lib}", "-L#{libbson.lib}",
           "-lmongoc-1.0", "-lbson-1.0",
           "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
