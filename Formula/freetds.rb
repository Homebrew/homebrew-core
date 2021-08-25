class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.3.2.tar.gz"
  sha256 "83155c77792ebb5fba63130d78ee2f347e3a619fa640ff72f290f7c3120ea223"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "06b6fb06e311ca1bc94cf6f8fdcbe24592d0238e80696036e576fa544c19c413"
    sha256 big_sur:       "234da94cf730ce359bdc5210359cc8c710ff3f1d29719ddf53bd77ea710e58b5"
    sha256 catalina:      "976c1cb4b0b18d8aa39bed8a11372cbc2fb85a72d024dee5b602fe1e8af47494"
    sha256 mojave:        "a9b79f72f2fd25c354e7d03df73162aa63795a13ca3912e23fa721fc16c0b56b"
    sha256 x86_64_linux:  "b774e618086f415512d18a0d47af89ee8f581b6390b5e3836599176cecaa1ac0"
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
