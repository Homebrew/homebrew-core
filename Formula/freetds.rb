class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.20.tar.gz"
  sha256 "0d4808d4e1ae5ecddc89c70402e6719eb3b41121c0c5d5af456c050615e3df85"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4ccd778e4acfa7aaa1a8747a5cdf9bbc9e440518f59f0357910e1c47a135fec5"
    sha256 big_sur:       "69d954c0e4ac3a606fc82f591f7ed7c1f28d34fb284a47e28cb4e9dc8e813ca7"
    sha256 catalina:      "1f66406bd2a80abcab6c67f4931bc04b167d6bf5c3c0bff529cfbb1af1698ba7"
    sha256 mojave:        "c4f5917d776f671fe6847ab4c36bc7fac44139e510e30f584ba93ee55a29377b"
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
