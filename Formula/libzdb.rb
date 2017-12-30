class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 4

  bottle do
    cellar :any
    sha256 "4cbb32921ac9edc6308ac6ac0d26553661d6ea3f154c62af9c3aaf63d2afdf58" => :high_sierra
    sha256 "9cec69cc93f6b975d95c506f3c7b04a4d2934ac30adc13afedd1d32fe2e31d8c" => :sierra
    sha256 "0a7bc557e3e91db185787147df1a87ae9c7aef33a1b57875bc74daa52a1338c8" => :el_capitan
    sha256 "3a5394289ceffbd2bc7bde8dd4dfad4f9b27a4d0180fab199a839c44739f0344" => :yosemite
  end

  depends_on "openssl"
  depends_on :postgresql => :recommended
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
