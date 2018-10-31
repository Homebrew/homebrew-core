class FreetdsAT091 < Formula
  desc "Libraries to talk to Microsoft SQL Server & Sybase"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-0.91.112.tar.gz"
  sha256 "be4f04ee57328c32e7e7cd7e2e1483e535071cec6101e46b9dd15b857c5078ed"
  revision 1

  bottle do
    sha256 "2e7675f7e1747c23583ff1d005f2d37f64159609d48993577813502f68010671" => :mojave
    sha256 "d5c53abae01fa996e458c240358f75aa5f34ec628637d9e20ae654c81a45f285" => :high_sierra
    sha256 "1458764cb5cb70d4b514502d3c94c0827dbba251cd03ff76960601e63f52faa1" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "unixodbc"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-krb5
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-tdsver=7.1
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
