class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "https://www.acme.com/software/http_load/"
  url "https://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"
  revision 1

  bottle do
    cellar :any
    sha256 "002c9e11e41446466d42dfe8f094019dcb80541564eca948c6d91abfd99720b1" => :mojave
    sha256 "99aa7a6ff01be1c5966127174bd9eb7739488f5b4845c96fb66f44055badf2b0" => :high_sierra
    sha256 "d0ee5757f7b530a23d0c27f603e7bf237599f4d279ea9c9261f1417e7ed3cf97" => :sierra
    sha256 "70f69abf54c027ae1397ccd17b61e66108a5dbd03e8edd8db1ff6af0f8f135d9" => :el_capitan
    sha256 "f4702e82a17b0c972164f2bc8ba985edccf0f3dc840627d37d5307d9b914ba25" => :yosemite
  end

  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
      SSL_TREE=#{Formula["openssl"].opt_prefix}
    ]

    inreplace "Makefile", "#SSL_", "SSL_"
    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "https://brew.sh/"
    system "#{bin}/http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
