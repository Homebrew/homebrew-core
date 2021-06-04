class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.21.tar.gz"
  sha256 "6d70c87eb4f5f2d27b5c812d515befd6b17b8aaa5355eb7cd6210c00f61f7190"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6f2f2ba797576835a4ff365d2fe84add54929fee5d257bf6ba1693f4ab5d976c"
    sha256 big_sur:       "5c9dfc5df86bae027e729b766b3454cf4935769fffe32a64abd495978b6688d5"
    sha256 catalina:      "9ece1ded3d098d4edb80a12885c9ad68034f437661e0181bb69ece9b9730c302"
    sha256 mojave:        "d3b54b49e043011c860f49047c33cc9cbc0be123e60f9c055a0861fec9d0a9aa"
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
