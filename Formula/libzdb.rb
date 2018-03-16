class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 5

  bottle do
    cellar :any
    sha256 "0cddd7b921c780f8f85be6b052ddcd20e49dd7f942279e2e86be497a43c06a28" => :high_sierra
    sha256 "f45dc243aad03c482b81752287cc7d552ad6d5e4e7dd9d739e0f705f84833ad5" => :sierra
    sha256 "9a1722fcff2c7946689a01b65c3151f6f2a9a26a43d50cfbb75ffe816a0a6c12" => :el_capitan
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
