class MongoC < Formula
  desc "Official C driver for MongoDB"
  homepage "https://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.3.5/mongo-c-driver-1.3.5.tar.gz"
  sha256 "374d37a6d6e49fbb2ed6cab0a305ced347651ec04d57808961d03afa8caa68df"

  bottle do
    cellar :any
    sha256 "6571abb550a8146d222858b7de9caae8380811ccf8846f27f99c4e50effde596" => :yosemite
    sha256 "3eb421698b3dd3a4a9ebc0d6a204904e14b8282165e02b539b1618280707d20c" => :mavericks
    sha256 "c8bbcc45d57d43297b38632b1890e77613509ae3bd497f84ba18dd6e3e9264ba" => :mountain_lion
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
