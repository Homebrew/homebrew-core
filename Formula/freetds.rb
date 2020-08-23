class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.3.tar.gz"
  sha256 "50ca5f54a76088fcf54873d76806996c6f43a7b6defafafa2b11060caf2e05b8"
  license "LGPL-2.0"

  bottle do
    sha256 "6aa188d6d4c85197a3bbaf9b1875562e4b6bf855328568e294233f98557ea5b6" => :catalina
    sha256 "0c3ec566c5f569b214c94d1d1508353cd9d34f8d3122ae0e3dd9e20881f808ab" => :mojave
    sha256 "85284f991ca3fa052a571bcb52b09ef17073ca5133a74f2eaca7a349215d56cf" => :high_sierra
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
