class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.32.tar.gz"
  sha256 "8f73036a5f0fdfaa6504ccd67f06332f1329531ff106308cc2453a69368d1ed8"

  bottle do
    sha256 "24d60daf6ab7b2ab0bf424def60709e3013bb8eced3b4a0af9fe60287a82d7cb" => :catalina
    sha256 "ea0ab1838f8acb52d89552c5a8a8c1a8a596f89392a907f21157d5bb2ea96cf6" => :mojave
    sha256 "08f933ed9f847d11c96d67a1aef0eadb81b80e2d283147b8708a9914c55c8e64" => :high_sierra
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
