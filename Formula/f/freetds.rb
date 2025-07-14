class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.4.tar.bz2"
  sha256 "1d024ef418d74a3a8f2cca82f10f1561f1dde28dc3d6f65c815f07764d4f7ea8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e2d39065bdad88c14d75e029e39f9cf01f77e2c122e07c8a70b64d44017b1554"
    sha256 arm64_sonoma:  "297766108da331613944a346edef42808128b22b7a5a59cb92c606939d6e049e"
    sha256 arm64_ventura: "ad86c54e8f7bb44364836eb3e427273e53f2c2d0240018bd3ad979ec995442df"
    sha256 sonoma:        "4d7d3a0e65cd04ba4c63a68dc39d3ad0a8cdc52010f356e4c1117d0ee3ea087b"
    sha256 ventura:       "79ce3d3a5016b066dc79e6cafd88fd57b3034d49cfef1ab607e7c7f30a05b3fd"
    sha256 arm64_linux:   "9c730658234286c9a0519bcfe7a4ca8cf92fbbb3a359c32538b11bd059a40ba5"
    sha256 x86_64_linux:  "a92decbd7230bb2df6a4fca029bf6093971f97fbbc058b84e036304d1dc73d8d"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

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
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin/"tsql", "-C"
  end
end
