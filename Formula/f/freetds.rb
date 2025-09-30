class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.6.tar.bz2"
  sha256 "dadc08e69aef14523fdaee09170d59daf1b6413e8d5858d09c9496674ba08c57"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e22c2302657e10ec121a58cd4207c4c4e04b4f96b8b2ddd7ecf50d51f2a6d1cf"
    sha256 arm64_sequoia: "011659518b8b178ffbe090bd9245313136b7934973d0c52ec20fda09f482537c"
    sha256 arm64_sonoma:  "3b8044ed3ca28d89636a1b1388f7d579cd5a0d313282c8a5c7e9abb02d661fc7"
    sha256 arm64_ventura: "09a5246c22c1798b392b273bd65f511d77c43f30fc3978261f46a07f2233d562"
    sha256 sonoma:        "b2fd3998afa3d813fd2028433c6a563c08d2ea7fc08582aeb8b50dbfda24bdcf"
    sha256 ventura:       "01a015e5c54b0aa13736f5426eee591e3f9db06fbc98cd42705d6a98281782cb"
    sha256 arm64_linux:   "e48c2e0c2d705fd05966fce93f49063bb27735efb486354659662404b6d1660c"
    sha256 x86_64_linux:  "62fca5064596a059cf95f75e525779ecc25531e83399f261eebf38dfc16c532e"
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
