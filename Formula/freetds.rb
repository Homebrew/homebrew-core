class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.tar.gz"
  sha256 "c0a7c8bacd0a3afbc19cffa096b68f28d7470efcb6797ec51a4fa369cadd79a4"

  bottle do
    sha256 "4439fa4a447b0c5f76de3e5020ec738e2dd063f0486fe371b3aa4d9dd19874ac" => :catalina
    sha256 "c89ee6b8be3e5dabf8c9f5d9cffed3e2f4d4edc6b995dbd4e3c7d141fd511f48" => :mojave
    sha256 "c13383b692718c10115a890e7db5d3ca45ff8e15f695368a51d87886a4d1214d" => :high_sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
