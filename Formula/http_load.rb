class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "https://www.acme.com/software/http_load/"
  url "https://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"

  bottle do
    cellar :any_skip_relocation
    sha256 "066db733e2ca22f30545f7131ad2833b3c16559a769fb2ce18686336066d6466" => :sierra
    sha256 "b7afff0a015534e8db9ba4e957014225bbf446c97378769a193da2e3753b14bc" => :el_capitan
    sha256 "6a38746183341a185ac3f7da57afc365707c2647ebaa0dc1d836b670b9bae35e" => :yosemite
    sha256 "0ba139d6c0adc4b5843bbbf3ce677ad58335029e7d4de0a18201bff0082e1e19" => :mavericks
  end

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
