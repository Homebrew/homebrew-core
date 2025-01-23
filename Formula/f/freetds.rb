class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.24.tar.bz2", using: :homebrew_curl
  sha256 "07cea1b457f8fd5bad75bc342371b7e7e092f9247a813dc7b627c9235dfdb642"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "071491d4e91b606f22f9d949ff1663b510c213860d088e87b8daef2411dff4d5"
    sha256 arm64_sonoma:  "affaf11454953f88770620dec477293fc733c5f440c035b1b3037a9ba7918b84"
    sha256 arm64_ventura: "91fc612f0feecd33ab18dd069a712da552697a288186c7990879905759b72f20"
    sha256 sonoma:        "df1b432689c6a6356b52220cd39c1e9fc4c0ff17f8d9ebbe8cd86a7a88632ade"
    sha256 ventura:       "8d3ca6c918d6ffc87abd1f8748baae67f67a099f4dc6d8952f88895ee6b49136"
    sha256 x86_64_linux:  "24c97bff8d493dd08d8aa160f584e5df8c3e962b6b5a098a1dc284c309fac343"
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
