class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 6

  bottle do
    cellar :any
    sha256 "dc81f4b36c4392f9bf92d815c44ec389a12b51530d93544e43ec1fd13c659f6d" => :mojave
    sha256 "0ee242c3eda134c97d3c79d2a03edc4b4a9d21c9b4ecdd81b141af6458b470f0" => :high_sierra
    sha256 "1a04349cc276e0f5d8fc63a291cc0be6d455fbd9cc9fdaa9711b4fa67c5da22b" => :sierra
    sha256 "051d58c0f1b5f39bebf8966311553f8be784daf7693e2b6960030aa791586803" => :el_capitan
  end

  depends_on "mysql-client"
  depends_on "openssl"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
