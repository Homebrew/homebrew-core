class MongoC < Formula
  desc "Official C driver for MongoDB"
  homepage "https://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.3.5/mongo-c-driver-1.3.5.tar.gz"
  sha256 "374d37a6d6e49fbb2ed6cab0a305ced347651ec04d57808961d03afa8caa68df"

  bottle do
    cellar :any
    sha256 "957985e1b8116c14580130080e8e64be76752ba78740a567358d690ef31271c6" => :el_capitan
    sha256 "e7e839c0e58f4b011d8faeffd46600f907269de88b8c16d0e846a4a30f2334f6" => :yosemite
    sha256 "572b100658a0957ab4ec74bd120e0572779049593647c320c5db89ada431dd21" => :mavericks
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "libbson",
                 :because => "mongo-c installs the libbson headers"

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended

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
