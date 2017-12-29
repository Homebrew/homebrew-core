class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 5

  bottle do
    cellar :any
    sha256 "e0792a7e6229efcc7ecc0de43200894c24154d6e2ea449ff7e017dca4f4eaa3f" => :high_sierra
    sha256 "a32526308ecc7e240b5bf21e05eaebb6b69c3be97c13e192c6e4007835887988" => :sierra
    sha256 "05ef421466fafc46b51d9aa12716525da0a97cf66b1a1434af34662ec43ed9d8" => :el_capitan
  end

  depends_on "openssl"
  depends_on "postgresql" => :recommended
  depends_on "mysql" => :recommended
  depends_on "sqlite" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--without-postgresql" if build.without? "postgresql"
    args << "--without-mysql" if build.without? "mysql"
    args << "--without-sqlite" if build.without? "sqlite"

    system "./configure", *args
    system "make", "install"
  end
end
