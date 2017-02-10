class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 3

  bottle do
    cellar :any
    sha256 "9967ba5917ccaa97f0b21cc823336244b91c1375827e435828ce79c2bf47a92b" => :sierra
    sha256 "d81e3d7cff1d212b7fc0d016b132b182052d1852127b3e756474302f16f1f52d" => :el_capitan
    sha256 "897732ae462579b760269990415b881fba81cc21b699cd04206a5d179090806e" => :yosemite
  end

  depends_on "openssl"
  depends_on :postgresql => :recommended
  depends_on :mysql => :recommended
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
