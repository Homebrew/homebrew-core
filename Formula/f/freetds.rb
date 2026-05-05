class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.17.tar.bz2"
  sha256 "6dee48026b7e3e2393d3ea3ce18f8f81a74d6a0f300e9951981ed7bf4de6bbc3"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0f70d14f9893f2fe765f5a5962baf3ebbae46a5608ea292821d81255faf97b31"
    sha256 arm64_sequoia: "9dfa514019c75726177cf6157d298ae2d5fe96ae52835305143eb4fbcc003ce0"
    sha256 arm64_sonoma:  "dfaae0806c52b1e0e813c52e1b50606f61013127e6d742df6095975045efd6e2"
    sha256 sonoma:        "1ec7ff28bdcd5e137e96e3393afe143042aa9cc6e04ce56e10993805af9b0577"
    sha256 arm64_linux:   "6f8d8307973d77c15b55f90240d1fd03ac00a836e6976f6cdd1bfe8a46b61099"
    sha256 x86_64_linux:  "b174665646a1c2345b6fb38d1a5721edf1cade3397976021034a5aae01dab8b6"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
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
      --with-openssl=#{Formula["openssl@4"].opt_prefix}
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
