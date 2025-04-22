class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.1.tar.bz2"
  sha256 "6146fde211b00583fad3c6d10030cfa664a744e0f5ae6b87edfd657bdf463b05"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fa36d93f35d399b3ac810444a8deb7073163cbda72c5cbd4fe9604dae95d6d09"
    sha256 arm64_sonoma:  "306e1cdc9a2005916057c0ad5068e44fcdaf35ec542c4a3550fa93a2fe3dff46"
    sha256 arm64_ventura: "aa7aaea426d007978e835ce3eb7aeaa71b0981c49e239d4afde811e0405f98d1"
    sha256 sonoma:        "bc72937049cd5bda2680dca0967c278111d3c30d96f5f449528baaf6b5c85e96"
    sha256 ventura:       "9e2f9192028486b82494a5d649c59afbdff60f5ba6ada944fe75ded9467746be"
    sha256 arm64_linux:   "3c163b7c2096f3f30951894621e277b3ff12b9417bcdec962f277c7e0053b747"
    sha256 x86_64_linux:  "d533db0a593c581953265be01d7efd520147dc9adf92df40590dc9e877efd3d7"
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
