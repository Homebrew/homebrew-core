class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "http://www.acme.com/software/http_load/"
  url "http://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"

  option "with-openssl", "Build with OpenSSL for HTTPS support"

  depends_on "openssl" => :optional

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
    ]

    if build.with? "openssl"
      inreplace "Makefile", "#SSL_", "SSL_"
      args << "SSL_TREE=#{Formula["openssl"].opt_prefix}"
    end

    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "http://brew.sh"
    system "#{bin}/http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
